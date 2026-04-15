# Created with the Assistance of Claude Code
# backend/app/api/v1/research.py
"""
Research Data API — Individual Anonymized Responses & Aggregate Analytics

Endpoints:
- GET  /surveys                           - List surveys with response counts
- GET  /surveys/{id}/overview             - Survey overview stats
- GET  /surveys/{id}/responses            - Individual anonymized response rows
- GET  /surveys/{id}/aggregates           - All question aggregates (filterable)
- GET  /surveys/{id}/aggregates/{qid}     - Single question aggregate
- GET  /surveys/{id}/export/csv           - CSV download of individual responses
- GET  /cross-survey/overview             - Data bank overview stats
- GET  /cross-survey/questions            - Available questions for field picker
- GET  /cross-survey/responses            - Data bank individual responses
- GET  /cross-survey/aggregates           - Data bank aggregate stats for charts
- GET  /cross-survey/export/csv           - Data bank CSV download

All endpoints require researcher (RoleID=2) or admin (RoleID=4) role.
Individual responses use anonymized participant IDs (SHA-256 hash).
Data is suppressed if fewer than 5 distinct respondents (k-anonymity).

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from typing import Optional
import io

from ...utils.utils import get_db_connection
from ..deps import require_role
from ...services.aggregation import AggregationService
from ...services.settings import get_int_setting

router = APIRouter()
_aggregation = AggregationService()


# ---------------------------------------------------------------------------
# Pydantic response models
# ---------------------------------------------------------------------------

class ResearchSurvey(BaseModel):
    survey_id: int
    title: str
    publication_status: str
    response_count: int
    question_count: int


class SurveyOverviewResponse(BaseModel):
    survey_id: int
    title: str
    respondent_count: int
    completion_rate: float
    question_count: int
    suppressed: bool
    reason: Optional[str] = None
    min_responses: int = 5


class QuestionAggregateResponse(BaseModel):
    question_id: int
    question_content: str
    response_type: str
    category: Optional[str] = None
    response_count: int
    suppressed: bool
    reason: Optional[str] = None
    data: Optional[dict] = None


class AggregateListResponse(BaseModel):
    survey_id: int
    title: str
    total_respondents: int
    aggregates: list[QuestionAggregateResponse]


class ResponseQuestion(BaseModel):
    question_id: int
    question_content: str
    response_type: str
    category: Optional[str] = None


class ResponseRow(BaseModel):
    anonymous_id: str
    responses: dict[str, str]


class IndividualResponseData(BaseModel):
    survey_id: int
    title: str
    respondent_count: int
    suppressed: bool
    reason: Optional[str] = None
    questions: list[ResponseQuestion]
    rows: list[ResponseRow]


# Cross-survey models

class CrossSurveyQuestion(BaseModel):
    question_id: int
    question_content: str
    response_type: str
    category: Optional[str] = None
    survey_id: int
    survey_title: str
    survey_start_date: Optional[str] = None


class CrossSurveyRow(BaseModel):
    anonymous_id: str
    responses: dict[str, str]


class CrossSurveySummary(BaseModel):
    survey_id: int
    title: str
    respondent_count: int


class CrossSurveyOverviewResponse(BaseModel):
    survey_ids: list[int]
    surveys: list[CrossSurveySummary]
    total_respondent_count: int
    total_question_count: int
    avg_completion_rate: float
    suppressed: bool
    reason: Optional[str] = None
    min_responses: int = 5


class CrossSurveyResponseData(BaseModel):
    survey_ids: list[int]
    surveys: list[CrossSurveySummary]
    total_respondent_count: int
    date_from: Optional[str] = None
    date_to: Optional[str] = None
    suppressed: bool
    reason: Optional[str] = None
    suppressed_surveys: list[int] = []
    questions: list[CrossSurveyQuestion]
    rows: list[CrossSurveyRow]


class CrossSurveyAggregateResponse(BaseModel):
    survey_ids: list[int]
    total_respondents: int
    aggregates: list[QuestionAggregateResponse]


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@router.get("/surveys", response_model=list[ResearchSurvey])
def list_research_surveys(user=Depends(require_role(2, 4))):
    """List all surveys with response counts for the researcher."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT
                s.SurveyID,
                s.Title,
                s.PublicationStatus,
                COUNT(DISTINCT r.ParticipantID) AS response_count,
                (SELECT COUNT(*) FROM QuestionList ql WHERE ql.SurveyID = s.SurveyID) AS question_count
            FROM Survey s
            LEFT JOIN Responses r ON r.SurveyID = s.SurveyID
            GROUP BY s.SurveyID, s.Title, s.PublicationStatus
            ORDER BY s.SurveyID DESC
            """
        )
        rows = cur.fetchall()
        return [
            ResearchSurvey(
                survey_id=row["SurveyID"],
                title=row["Title"],
                publication_status=row["PublicationStatus"],
                response_count=row["response_count"],
                question_count=row["question_count"],
            )
            for row in rows
        ]
    finally:
        cur.close()
        conn.close()


@router.get("/surveys/{survey_id}/overview", response_model=SurveyOverviewResponse)
def get_survey_overview(survey_id: int, user=Depends(require_role(2, 4))):
    """Get high-level stats for a survey."""
    result = _aggregation.get_survey_overview(survey_id)
    if result is None:
        raise HTTPException(status_code=404, detail="Survey not found")
    return SurveyOverviewResponse(**result, min_responses=get_int_setting("k_anonymity_threshold"))


@router.get("/surveys/{survey_id}/responses", response_model=IndividualResponseData)
def get_individual_responses(
    survey_id: int,
    category: Optional[str] = Query(None, description="Filter by question category"),
    response_type: Optional[str] = Query(None, description="Filter by response type"),
    user=Depends(require_role(2, 4)),
):
    """Get individual anonymized response rows for a survey."""
    result = _aggregation.get_individual_responses(
        survey_id, category=category, response_type=response_type
    )
    if result is None:
        raise HTTPException(status_code=404, detail="Survey not found")
    return IndividualResponseData(**result)


@router.get("/surveys/{survey_id}/aggregates", response_model=AggregateListResponse)
def get_survey_aggregates(
    survey_id: int,
    category: Optional[str] = Query(None, description="Filter by question category"),
    response_type: Optional[str] = Query(None, description="Filter by response type"),
    user=Depends(require_role(2, 4)),
):
    """Get aggregate data for all questions in a survey."""
    result = _aggregation.get_survey_aggregates(
        survey_id, category=category, response_type=response_type
    )
    if result is None:
        raise HTTPException(status_code=404, detail="Survey not found")
    return AggregateListResponse(**result)


@router.get(
    "/surveys/{survey_id}/aggregates/{question_id}",
    response_model=QuestionAggregateResponse,
)
def get_question_aggregate(
    survey_id: int, question_id: int, user=Depends(require_role(2, 4))
):
    """Get aggregate data for a single question."""
    result = _aggregation.get_question_aggregate(survey_id, question_id)
    if result is None:
        raise HTTPException(status_code=404, detail="Question not found in survey")
    return QuestionAggregateResponse(**result)


@router.get("/surveys/{survey_id}/export/csv")
def export_csv(
    survey_id: int,
    category: Optional[str] = Query(None),
    response_type: Optional[str] = Query(None),
    user=Depends(require_role(2, 4)),
):
    """Export individual anonymized response data as CSV download."""
    # Look up survey title for CSV metadata
    overview = _aggregation.get_survey_overview(survey_id)
    title = overview["title"] if overview else None
    csv_data = _aggregation.get_individual_csv_export(
        survey_id, category=category, response_type=response_type,
        survey_title=title,
    )
    if csv_data is None:
        raise HTTPException(status_code=404, detail="Survey not found")

    # Use survey title in filename (sanitized)
    safe_title = (title or f"survey_{survey_id}").replace(" ", "_").replace("/", "_")
    return StreamingResponse(
        io.StringIO(csv_data),
        media_type="text/csv",
        headers={
            "Content-Disposition": f"attachment; filename={safe_title}_responses.csv"
        },
    )


# ---------------------------------------------------------------------------
# Cross-survey endpoints
# ---------------------------------------------------------------------------

@router.get("/cross-survey/overview", response_model=CrossSurveyOverviewResponse)
def get_cross_survey_overview(
    survey_ids: Optional[list[int]] = Query(None, description="Survey IDs (omit for all)"),
    date_from: Optional[str] = Query(None, description="Start date YYYY-MM-DD"),
    date_to: Optional[str] = Query(None, description="End date YYYY-MM-DD"),
    user=Depends(require_role(2, 4)),
):
    """Get overview stats across surveys. Omit survey_ids for all surveys."""
    result = _aggregation.get_cross_survey_overview(
        survey_ids or None, date_from=date_from, date_to=date_to
    )
    return CrossSurveyOverviewResponse(**result, min_responses=get_int_setting("k_anonymity_threshold"))


@router.get("/cross-survey/questions", response_model=list[CrossSurveyQuestion])
def get_available_questions(
    survey_ids: Optional[list[int]] = Query(None, description="Filter by survey IDs"),
    category: Optional[str] = Query(None, description="Filter by question category"),
    response_type: Optional[str] = Query(None, description="Filter by response type"),
    user=Depends(require_role(2, 4)),
):
    """List all available questions in the data bank for field selection."""
    result = _aggregation.get_available_questions(
        survey_ids or None, category=category, response_type=response_type
    )
    return [CrossSurveyQuestion(**q) for q in result]


@router.get("/cross-survey/responses", response_model=CrossSurveyResponseData)
def get_cross_survey_responses(
    survey_ids: Optional[list[int]] = Query(None, description="Survey IDs (omit for all)"),
    question_ids: Optional[list[int]] = Query(None, description="Specific question IDs"),
    category: Optional[str] = Query(None, description="Filter by question category"),
    response_type: Optional[str] = Query(None, description="Filter by response type"),
    date_from: Optional[str] = Query(None, description="Start date YYYY-MM-DD"),
    date_to: Optional[str] = Query(None, description="End date YYYY-MM-DD"),
    user=Depends(require_role(2, 4)),
):
    """Get individual anonymized response rows. Omit survey_ids for all surveys."""
    result = _aggregation.get_cross_survey_responses(
        survey_ids or None,
        date_from=date_from,
        date_to=date_to,
        category=category,
        response_type=response_type,
        question_ids=question_ids or None,
    )
    return CrossSurveyResponseData(**result)


@router.get("/cross-survey/aggregates", response_model=CrossSurveyAggregateResponse)
def get_cross_survey_aggregates(
    survey_ids: Optional[list[int]] = Query(None, description="Survey IDs (omit for all)"),
    question_ids: Optional[list[int]] = Query(None, description="Specific question IDs"),
    category: Optional[str] = Query(None, description="Filter by question category"),
    response_type: Optional[str] = Query(None, description="Filter by response type"),
    date_from: Optional[str] = Query(None, description="Start date YYYY-MM-DD"),
    date_to: Optional[str] = Query(None, description="End date YYYY-MM-DD"),
    user=Depends(require_role(2, 4)),
):
    """Get aggregate stats across the data bank for charting."""
    result = _aggregation.get_cross_survey_aggregates(
        survey_ids or None,
        question_ids=question_ids or None,
        date_from=date_from,
        date_to=date_to,
        category=category,
        response_type=response_type,
    )
    return CrossSurveyAggregateResponse(**result)


@router.get("/cross-survey/export/csv")
def export_cross_survey_csv(
    survey_ids: Optional[list[int]] = Query(None, description="Survey IDs (omit for all)"),
    question_ids: Optional[list[int]] = Query(None, description="Specific question IDs"),
    category: Optional[str] = Query(None),
    response_type: Optional[str] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    user=Depends(require_role(2, 4)),
):
    """Export data bank individual response data as CSV download."""
    csv_data = _aggregation.get_cross_survey_csv_export(
        survey_ids or None,
        date_from=date_from,
        date_to=date_to,
        category=category,
        response_type=response_type,
        question_ids=question_ids or None,
    )
    if csv_data is None:
        raise HTTPException(status_code=404, detail="No surveys found")

    return StreamingResponse(
        io.StringIO(csv_data),
        media_type="text/csv",
        headers={
            "Content-Disposition": "attachment; filename=data_bank_export.csv"
        },
    )
