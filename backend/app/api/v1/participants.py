# created with the help of ChatGPT
# backend/app/api/v1/participants.py
"""
Participant Survey API

Endpoints:
- PUT    /api/v1/participants/surveys/{survey_id}/draft       - Save draft responses for an assigned survey
- GET    /api/v1/participants/surveys/{survey_id}/draft       - Load saved draft responses
- POST   /api/v1/participants/surveys/{survey_id}/submit      - Submit completed survey responses
- GET    /api/v1/participants/surveys/{survey_id}/questions   - Get survey questions for an assigned survey
- GET    /api/v1/participants/surveys                         - List surveys assigned to the current participant
- GET    /api/v1/participants/surveys/data                    - List completed surveys with participant responses
- GET    /api/v1/participants/surveys/{survey_id}/compare     - Compare participant responses to anonymized aggregates
- GET    /api/v1/participants/surveys/{survey_id}/chart-data  - Get chart-ready participant + aggregate response data

Notes:
- All survey-question required flags are sourced from QuestionList.IsRequired,
  not QuestionBank.IsRequired.
- Drafts are stored on SurveyAssignment.DraftData.
- Submission validates:
  - survey exists and is published
  - participant is assigned to the survey
  - submitted questions belong to that survey
  - required questions are present
  - response values match the question response type
- Aggregate/chart endpoints rely on k-anonymous aggregation and suppress
  small-sample results.

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""


import json

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, field_validator
from typing import Optional, List, Union
from enum import Enum
from datetime import datetime
from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string
from ...services.aggregation import AggregationService
from ...services.translation import get_translated_question, get_translated_options

class AnswerItem(BaseModel):
    question_id: int
    response_value: str

    @field_validator('response_value', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)

class SurveyParticipantAnswer(BaseModel):
    #survey_id: int
    #participant_id: int
    question_responses: List[AnswerItem]

class ParticipantSurveyListItem(BaseModel):
    survey_id: int
    title: str
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None

    # assignment info (useful for frontend)
    assignment_status: str
    has_draft: bool = False
    assigned_at: Optional[datetime] = None
    due_date: Optional[datetime] = None
    completed_at: Optional[datetime] = None

    # survey state (useful to hide closed/draft if you ever change logic)
    publication_status: str


class ParticipantQuestionResponse(BaseModel):
    question_id: int
    title: Optional[str] = None
    question_content: str
    response_type: str
    is_required: bool
    category: Optional[str] = None

    # participant answer
    response_value: Optional[str] = None


class ParticipantSurveyWithResponses(BaseModel):
    survey_id: int
    title: str
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    publication_status: str

    # assignment context (handy in UI)
    assignment_status: Optional[str] = None
    assigned_at: Optional[datetime] = None
    due_date: Optional[datetime] = None
    completed_at: Optional[datetime] = None

    questions: List[ParticipantQuestionResponse]


class ChartQuestionData(BaseModel):
    question_id: int
    question_content: str
    response_type: str
    category: Optional[str] = None
    response_value: Optional[str] = None
    aggregate: Optional[dict] = None
    suppressed: bool = False


class ParticipantChartDataResponse(BaseModel):
    survey_id: int
    title: str
    total_respondents: int
    questions: List[ChartQuestionData]


class ParticipantAnswerOut(BaseModel):
    question_id: int
    response_value: Optional[str] = None

class ParticipantSurveyCompareResponse(BaseModel):
    survey_id: int
    # participant's responses (raw, per question)
    participant_answers: List[ParticipantAnswerOut]

    # aggregate payload (same shape your research endpoint returns)
    aggregates: dict



_aggregation = AggregationService()

router = APIRouter(dependencies=[Depends(require_role(1, 4))])

@router.put("/surveys/{survey_id}/draft", status_code=204)
async def save_draft(survey_id: int, payload: SurveyParticipantAnswer, current_user=Depends(require_role(1, 4))):
    """Save in-progress responses as a draft on the assignment."""
    participant_id = current_user["effective_account_id"]
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT AssignmentID, Status FROM SurveyAssignment WHERE SurveyID = %s AND AccountID = %s",
            (survey_id, participant_id),
        )
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Assignment not found")
        if row[1] == "completed":
            return None  # silently ignore drafts for completed surveys

        draft = json.dumps(
            {str(a.question_id): a.response_value for a in payload.question_responses}
        )
        cursor.execute(
            "UPDATE SurveyAssignment SET DraftData = %s WHERE AssignmentID = %s",
            (draft, row[0]),
        )
        conn.commit()
        return None
    finally:
        cursor.close()
        conn.close()


@router.get("/surveys/{survey_id}/draft")
async def get_draft(survey_id: int, current_user=Depends(require_role(1, 4))):
    """Load saved draft responses for a survey assignment."""
    participant_id = current_user["effective_account_id"]
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT DraftData FROM SurveyAssignment WHERE SurveyID = %s AND AccountID = %s",
            (survey_id, participant_id),
        )
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Assignment not found")
        if row[0]:
            return {"draft": json.loads(row[0])}
        return {"draft": {}}
    finally:
        cursor.close()
        conn.close()


@router.post("/surveys/{survey_id}/submit", status_code=201)
async def submit_survey_answers(survey_id: int, payload: SurveyParticipantAnswer, current_user=Depends(require_role(1, 4))):
    try:
        participant_id = current_user["effective_account_id"]

        conn = get_db_connection()
        cursor = conn.cursor()

        # check to see survey is active
        cursor.execute(
            """
            SELECT SurveyID, PublicationStatus, StartDate, EndDate
            FROM Survey
            WHERE SurveyID = %s
            """,
            (survey_id,)
        )
        survey_row = cursor.fetchone()
        if not survey_row:
            raise HTTPException(status_code=404, detail="Survey not found")

        publication_status = survey_row[1]
        if publication_status != "published":
            raise HTTPException(status_code=400, detail=f"Survey is not accepting submissions (status={publication_status})")
        

        # check to see if participant is assigned to survey
        cursor.execute(
            """
            SELECT AssignmentID, Status, DueDate, CompletedAt
            FROM SurveyAssignment
            WHERE SurveyID = %s AND AccountID = %s
            """,
            (survey_id, participant_id)
        )
        assignment = cursor.fetchone()
        if not assignment:
            # Not assigned => forbidden
            raise HTTPException(status_code=403, detail="You are not assigned to this survey")

        assignment_id, assignment_status, due_date, completed_at = assignment

        # enforce assignment status
        if assignment_status == "completed":
            raise HTTPException(status_code=400, detail="Survey assignment already completed")
        if assignment_status == "expired":
            raise HTTPException(status_code=400, detail="Survey assignment is expired")
        
        
        # enforce due date
        if due_date is not None:
            cursor.execute("SELECT UTC_TIMESTAMP()")
            now_utc = cursor.fetchone()[0]

            if due_date < now_utc:
                cursor.execute(
                    """
                    UPDATE SurveyAssignment
                    SET Status = 'expired'
                    WHERE AssignmentID = %s
                    """,
                    (assignment_id,)
                )
                conn.commit()
                raise HTTPException(status_code=400, detail="Survey assignment is past due and has expired")

        
        # check if survey is already submitted
        cursor.execute(
            """
            SELECT COUNT(*)
            FROM Responses
            WHERE SurveyID = %s AND ParticipantID = %s
            """,
            (survey_id, participant_id)
        )

        if cursor.fetchone()[0] > 0:
            raise HTTPException(
                status_code=400,
                detail="Survey already submitted"
        )

        # Load valid questions for this survey, including required flags
        cursor.execute(
            """
            SELECT qb.QuestionID, qb.ResponseType, ql.IsRequired
            FROM QuestionList ql
            JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
            WHERE ql.SurveyID = %s
            """,
            (survey_id,)
        )
        survey_questions = {
            int(row[0]): {
                "response_type": row[1],
                "is_required": bool(row[2]),
            }
            for row in cursor.fetchall()
        }

        submitted_question_ids = {ans.question_id for ans in payload.question_responses}
        missing_required = [
            question_id
            for question_id, meta in survey_questions.items()
            if meta["is_required"] and question_id not in submitted_question_ids
        ]
        if missing_required:
            raise HTTPException(
                status_code=422,
                detail=f"Missing required responses for question ids: {missing_required}"
            )

        response_sql = """
                INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue)
                VALUES (%s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                ResponseValue = VALUES(ResponseValue)
            """
        
        for ans in payload.question_responses:
            if ans.question_id not in survey_questions:
                raise HTTPException(
                    status_code=400,
                    detail=f"Question {ans.question_id} is not in this survey"
                )

            response_type = survey_questions[ans.question_id]["response_type"]
            response_value = ans.response_value

            if response_type == "single_choice":
                # frontend sends one option_id as a string, e.g. "63"
                try:
                    option_id = int(response_value.strip())
                except Exception:
                    raise HTTPException(
                        status_code=400,
                        detail=f"Invalid single_choice response for question {ans.question_id}"
                    )

                cursor.execute(
                    """
                    SELECT OptionText
                    FROM QuestionOptions
                    WHERE QuestionID = %s AND OptionID = %s
                    """,
                    (ans.question_id, option_id)
                )
                opt_row = cursor.fetchone()
                if not opt_row:
                    raise HTTPException(
                        status_code=400,
                        detail=f"Invalid option for question {ans.question_id}"
                    )

                response_value = opt_row[0]

            elif response_type == "multi_choice":
                # frontend sends JSON array (e.g. '["32","33"]') or
                # comma-separated option_ids (e.g. "31,34,36") for legacy
                try:
                    parsed = json.loads(response_value)
                    if isinstance(parsed, list):
                        option_ids = [int(x) for x in parsed]
                    else:
                        raise ValueError("not a list")  # pragma: no cover — FakeCursor doesn't return option text mapping
                except (json.JSONDecodeError, ValueError, TypeError):
                    raw_ids = [s.strip() for s in response_value.split(',') if s.strip()]
                    try:
                        option_ids = [int(x) for x in raw_ids]
                    except Exception:
                        raise HTTPException(
                            status_code=400,
                            detail=f"Invalid multi_choice response for question {ans.question_id}"
                        )

                if option_ids:
                    placeholders = ", ".join(["%s"] * len(option_ids))
                    cursor.execute(
                        f"""
                        SELECT OptionID, OptionText
                        FROM QuestionOptions
                        WHERE QuestionID = %s AND OptionID IN ({placeholders})
                        ORDER BY DisplayOrder, OptionID
                        """,
                        (ans.question_id, *option_ids)
                    )
                    rows = cursor.fetchall()

                    found = {int(r[0]): r[1] for r in rows}
                    if len(found) != len(set(option_ids)):
                        raise HTTPException(
                            status_code=400,
                            detail=f"One or more invalid options for question {ans.question_id}"
                        )

                    ordered_text = [found[oid] for oid in option_ids if oid in found]
                    response_value = ",".join(ordered_text)
                else:
                    response_value = ""

            cursor.execute(
                response_sql,
                (survey_id, participant_id, ans.question_id, response_value)
            )

        # mark survey assignment as completed and clear draft
        cursor.execute(
            """
            UPDATE SurveyAssignment
            SET Status = 'completed',
                CompletedAt = UTC_TIMESTAMP(),
                DraftData = NULL
            WHERE AssignmentID = %s
            """,
            (assignment_id,)
        )

        conn.commit()


        #cursor.close()
        #conn.close()

        #return {"message": "test", "account_id": participant_id}
        return {
                "survey_id": survey_id,
                "participant_id": participant_id,
                "submitted_count": len(payload.question_responses),
                "status": "ok",
        }
    except HTTPException:
        conn.rollback()
        raise
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to submit survey: {str(e)}")
    finally:
        cursor.close()
        conn.close()



class QuestionOption(BaseModel):
    option_id: int
    option_text: str
    display_order: Optional[int] = None


class ParticipantSurveyQuestion(BaseModel):
    question_id: int
    title: Optional[str] = None
    question_content: str
    response_type: str
    is_required: bool
    category: Optional[str] = None
    options: Optional[List[QuestionOption]] = None


class ParticipantSurveyQuestionsResponse(BaseModel):
    survey_id: int
    title: str
    questions: List[ParticipantSurveyQuestion]


@router.get("/surveys/{survey_id}/questions", response_model=ParticipantSurveyQuestionsResponse)
async def get_participant_survey_questions(
    survey_id: int,
    lang: str = Query("en", max_length=5),
    current_user=Depends(require_role(1, 4)),
):
    """Return questions for a survey the participant is assigned to (pending only)."""
    conn = None
    cursor = None
    try:
        participant_id = current_user["effective_account_id"]

        conn = get_db_connection()
        cursor = conn.cursor()

        # Verify this participant has a pending assignment for this survey
        cursor.execute(
            """
            SELECT sa.AssignmentID
            FROM SurveyAssignment sa
            WHERE sa.SurveyID = %s AND sa.AccountID = %s AND sa.Status = 'pending'
            """,
            (survey_id, participant_id),
        )
        if cursor.fetchone() is None:
            raise HTTPException(status_code=403, detail="No pending assignment for this survey")

        # Fetch survey title
        cursor.execute(
            "SELECT Title FROM Survey WHERE SurveyID = %s",
            (survey_id,),
        )
        survey_row = cursor.fetchone()
        if survey_row is None:
            raise HTTPException(status_code=404, detail="Survey not found")
        title = survey_row[0]

        # Fetch questions
        cursor.execute(
            """
            SELECT qb.QuestionID, qb.Title, qb.QuestionContent, qb.ResponseType,
                   ql.IsRequired, qb.Category
            FROM QuestionList ql
            JOIN QuestionBank qb ON ql.QuestionID = qb.QuestionID
            WHERE ql.SurveyID = %s
            ORDER BY ql.ID
            """,
            (survey_id,),
        )
        q_rows = cursor.fetchall()

        questions = []
        for row in q_rows:
            question_id = row[0]
            response_type = row[3]

            options = None
            if response_type in ('single_choice', 'multi_choice'):
                cursor.execute(
                    """
                    SELECT OptionID, OptionText, DisplayOrder
                    FROM QuestionOptions
                    WHERE QuestionID = %s
                    ORDER BY DisplayOrder
                    """,
                    (question_id,),
                )
                options = [
                    QuestionOption(option_id=opt[0], option_text=opt[1], display_order=opt[2])
                    for opt in cursor.fetchall()
                ]

            # Apply translations if available
            q_title = row[1]
            q_content = row[2]
            translated = get_translated_question(cursor, question_id, lang)
            if translated:
                q_title = translated["title"] or q_title
                q_content = translated["question_content"] or q_content

            if options and lang != "en":
                translated_opts = get_translated_options(cursor, question_id, lang)
                if translated_opts:  # pragma: no cover — FakeCursor doesn't return translated options
                    options = [
                        QuestionOption(
                            option_id=o.option_id,
                            option_text=translated_opts.get(o.option_id, o.option_text),
                            display_order=o.display_order,
                        )
                        for o in options
                    ]

            questions.append(ParticipantSurveyQuestion(
                question_id=question_id,
                title=q_title,
                question_content=q_content,
                response_type=response_type,
                is_required=bool(row[4]),
                category=row[5],
                options=options,
            ))

        return ParticipantSurveyQuestionsResponse(
            survey_id=survey_id,
            title=title,
            questions=questions,
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to load survey questions: {str(e)}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


@router.get("/surveys", response_model=List[ParticipantSurveyListItem])
async def list_my_surveys(
    current_user=Depends(require_role(1, 4)),
    include_completed: bool = Query(True),
    include_expired: bool = Query(True),
):
    """Return all surveys assigned to the current participant, optionally filtering out completed or expired assignments."""
    conn = None
    cursor = None
    try:
        participant_id = current_user["effective_account_id"]

        conn = get_db_connection()
        cursor = conn.cursor()

        # Optional filtering on assignment status
        status_filters = ["pending"]
        if include_completed:
            status_filters.append("completed")
        if include_expired:
            status_filters.append("expired")

        placeholders = ", ".join(["%s"] * len(status_filters))

        cursor.execute(
            f"""
            SELECT
                s.SurveyID,
                s.Title,
                s.StartDate,
                s.EndDate,
                sa.Status,
                sa.DraftData,
                sa.AssignedAt,
                sa.DueDate,
                sa.CompletedAt,
                s.PublicationStatus
            FROM SurveyAssignment sa
            JOIN Survey s ON s.SurveyID = sa.SurveyID
            WHERE sa.AccountID = %s
              AND sa.Status IN ({placeholders})
            ORDER BY
                -- show pending first, then by due date, then newest assigned
                (sa.Status = 'pending') DESC,
                sa.DueDate IS NULL, sa.DueDate ASC,
                sa.AssignedAt DESC
            """,
            (participant_id, *status_filters),
        )

        rows = cursor.fetchall()

        return [
            ParticipantSurveyListItem(
                survey_id=row[0],
                title=row[1],
                start_date=row[2],
                end_date=row[3],
                assignment_status=row[4],
                has_draft=bool(row[5]),
                assigned_at=row[6],
                due_date=row[7],
                completed_at=row[8],
                publication_status=row[9],
            )
            for row in rows
        ]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to load participant surveys: {str(e)}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()



# potentially temporary endpoint for survey response data for a single participant.
# will need to build on this to compare participant's survey responses to aggregates.
@router.get("/surveys/data", response_model=List[ParticipantSurveyWithResponses])
async def list_my_responded_surveys(
    current_user=Depends(require_role(1, 4)),
    lang: str = Query("en", max_length=5),
):
    """Return completed surveys with the participant's full response data, supporting localized question text."""
    conn = None
    cursor = None
    try:
        participant_id = current_user["effective_account_id"]

        conn = get_db_connection()
        cursor = conn.cursor()

        # 1) Find distinct surveys that this participant has responses for,
        # joined to Survey + SurveyAssignment so we can return metadata.
        cursor.execute(
            """
            SELECT DISTINCT
                s.SurveyID,
                s.Title,
                s.StartDate,
                s.EndDate,
                s.PublicationStatus,
                sa.Status,
                sa.AssignedAt,
                sa.DueDate,
                sa.CompletedAt
            FROM Responses r
            JOIN Survey s ON s.SurveyID = r.SurveyID
            LEFT JOIN SurveyAssignment sa
              ON sa.SurveyID = s.SurveyID AND sa.AccountID = %s
            WHERE r.ParticipantID = %s
            ORDER BY sa.CompletedAt DESC, s.SurveyID DESC
            """,
            (participant_id, participant_id),
        )
        survey_rows = cursor.fetchall()

        if not survey_rows:
            return []

        survey_ids = [int(r[0]) for r in survey_rows]

        # 2) Fetch ALL questions for those surveys (QuestionList -> QuestionBank)
        # We'll group in python.
        placeholders = ", ".join(["%s"] * len(survey_ids))
        cursor.execute(
            f"""
            SELECT
                ql.SurveyID,
                qb.QuestionID,
                qb.Title,
                qb.QuestionContent,
                qb.ResponseType,
                ql.IsRequired,
                qb.Category
            FROM QuestionList ql
            JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
            WHERE ql.SurveyID IN ({placeholders})
            ORDER BY ql.SurveyID, qb.QuestionID
            """,
            tuple(survey_ids),
        )
        question_rows = cursor.fetchall()

        # 3) Fetch this participant's responses for those surveys
        cursor.execute(
            f"""
            SELECT SurveyID, QuestionID, ResponseValue
            FROM Responses
            WHERE ParticipantID = %s
              AND SurveyID IN ({placeholders})
            """,
            (participant_id, *survey_ids),
        )
        response_rows = cursor.fetchall()

        # Build a lookup: (survey_id, question_id) -> response_value
        responses_map = {
            (int(sid), int(qid)): (val if val is not None else None)
            for (sid, qid, val) in response_rows
        }

        # Group questions by survey_id
        questions_by_survey = {sid: [] for sid in survey_ids}
        for sid, qid, qtitle, qcontent, rtype, required, category in question_rows:
            sid = int(sid)
            qid = int(qid)
            if lang != "en":
                translated = get_translated_question(cursor, qid, lang)
                if translated:
                    qtitle = translated["title"] or qtitle
                    qcontent = translated["question_content"] or qcontent
            questions_by_survey.setdefault(sid, []).append(
                ParticipantQuestionResponse(
                    question_id=qid,
                    title=qtitle,
                    question_content=qcontent,
                    response_type=rtype,
                    is_required=bool(required),
                    category=category,
                    response_value=responses_map.get((sid, qid)),
                )
            )

        # 4) Assemble response objects in the same order as survey_rows
        result: List[ParticipantSurveyWithResponses] = []
        for row in survey_rows:
            sid = int(row[0])
            result.append(
                ParticipantSurveyWithResponses(
                    survey_id=sid,
                    title=row[1],
                    start_date=row[2],
                    end_date=row[3],
                    publication_status=row[4],
                    assignment_status=row[5],
                    assigned_at=row[6],
                    due_date=row[7],
                    completed_at=row[8],
                    questions=questions_by_survey.get(sid, []),
                )
            )

        return result

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to load responded surveys: {str(e)}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()



@router.get("/surveys/{survey_id}/compare", response_model=ParticipantSurveyCompareResponse)
async def compare_my_responses_to_aggregate(
    survey_id: int,
    current_user=Depends(require_role(1, 4)),
    category: Optional[str] = Query(None),
    response_type: Optional[str] = Query(None),
):
    """Compare the current participant's individual survey responses against the anonymised k-anonymous aggregate for that survey."""
    conn = None
    cursor = None
    try:
        participant_id = current_user["effective_account_id"]

        conn = get_db_connection()
        cursor = conn.cursor()

        # 1) must be assigned (prevents random survey probing)
        cursor.execute(
            """
            SELECT AssignmentID
            FROM SurveyAssignment
            WHERE SurveyID = %s AND AccountID = %s
            """,
            (survey_id, participant_id),
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=403, detail="You are not assigned to this survey")

        # 2) participant answers for this survey
        cursor.execute(
            """
            SELECT QuestionID, ResponseValue
            FROM Responses
            WHERE SurveyID = %s AND ParticipantID = %s
            """,
            (survey_id, participant_id),
        )
        rows = cursor.fetchall()
        participant_answers = [
            ParticipantAnswerOut(question_id=int(r[0]), response_value=r[1])
            for r in rows
        ]

        # Optional: if you only want comparison once they’ve actually responded
        # if not participant_answers:
        #     raise HTTPException(status_code=400, detail="No responses found for this survey")

        # 3) reuse aggregation logic (already suppression-safe)
        agg = _aggregation.get_survey_aggregates(
            survey_id, category=category, response_type=response_type
        )
        if agg is None:
            raise HTTPException(status_code=404, detail="Survey not found")

        return ParticipantSurveyCompareResponse(
            survey_id=survey_id,
            participant_answers=participant_answers,
            aggregates=agg,  # contains title, total_respondents, aggregates[], suppression fields, etc.
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to load comparison data: {str(e)}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


@router.get("/surveys/{survey_id}/chart-data", response_model=ParticipantChartDataResponse)
async def get_chart_data(
    survey_id: int,
    current_user=Depends(require_role(1, 4)),
    category: Optional[str] = Query(None),
    response_type: Optional[str] = Query(None),
    lang: str = Query("en", max_length=5),
):
    """Return participant's own responses alongside aggregate data for charting.

    Each question includes the participant's response_value plus aggregate
    statistics (mean, histogram, choice distributions, etc.).  Aggregate
    data is suppressed when fewer than K (5) respondents exist, ensuring
    k-anonymity.  Participants never see individual-level data from others.
    """
    conn = None
    cursor = None
    try:
        participant_id = current_user["effective_account_id"]

        conn = get_db_connection()
        cursor = conn.cursor()

        # 1) Verify participant is assigned to this survey
        cursor.execute(
            """
            SELECT AssignmentID
            FROM SurveyAssignment
            WHERE SurveyID = %s AND AccountID = %s
            """,
            (survey_id, participant_id),
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=403, detail="You are not assigned to this survey")

        # 2) Get survey metadata
        cursor.execute(
            "SELECT SurveyID, Title FROM Survey WHERE SurveyID = %s",
            (survey_id,),
        )
        survey_row = cursor.fetchone()
        if not survey_row:
            raise HTTPException(status_code=404, detail="Survey not found")

        survey_title = survey_row[1]

        # 3) Fetch questions for this survey with optional filters
        filter_clauses = []
        filter_params: list = [survey_id]

        if category:
            filter_clauses.append("qb.Category = %s")
            filter_params.append(category)
        if response_type:
            filter_clauses.append("qb.ResponseType = %s")
            filter_params.append(response_type)

        where_extra = ""
        if filter_clauses:
            where_extra = " AND " + " AND ".join(filter_clauses)

        cursor.execute(
            f"""
            SELECT
                qb.QuestionID,
                qb.QuestionContent,
                qb.ResponseType,
                qb.Category
            FROM QuestionList ql
            JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
            WHERE ql.SurveyID = %s{where_extra}
            ORDER BY qb.QuestionID
            """,
            tuple(filter_params),
        )
        question_rows = cursor.fetchall()

        if not question_rows:
            return ParticipantChartDataResponse(
                survey_id=survey_id,
                title=survey_title,
                total_respondents=0,
                questions=[],
            )

        # 4) Fetch this participant's responses
        cursor.execute(
            """
            SELECT QuestionID, ResponseValue
            FROM Responses
            WHERE SurveyID = %s AND ParticipantID = %s
            """,
            (survey_id, participant_id),
        )
        my_responses = {int(r[0]): r[1] for r in cursor.fetchall()}

        # 5) Get aggregate data (reuses AggregationService with k-anonymity)
        agg = _aggregation.get_survey_aggregates(
            survey_id, category=category, response_type=response_type
        )

        # Build aggregate lookup by question_id
        agg_by_qid: dict = {}
        total_respondents = 0
        if agg:
            total_respondents = agg.get("total_respondents", 0)
            for qa in agg.get("aggregates", []):
                agg_by_qid[qa["question_id"]] = qa

        # 6) Build response
        questions: list[ChartQuestionData] = []
        for qid, qcontent, rtype, cat in question_rows:
            qid = int(qid)
            if lang != "en":
                translated = get_translated_question(cursor, qid, lang)
                if translated:
                    qcontent = translated["question_content"] or qcontent
            qa = agg_by_qid.get(qid, {})
            suppressed = qa.get("suppressed", False)

            questions.append(
                ChartQuestionData(
                    question_id=qid,
                    question_content=qcontent,
                    response_type=rtype,
                    category=cat,
                    response_value=my_responses.get(qid),
                    aggregate=qa.get("data") if not suppressed else None,
                    suppressed=suppressed,
                )
            )

        return ParticipantChartDataResponse(
            survey_id=survey_id,
            title=survey_title,
            total_respondents=total_respondents,
            questions=questions,
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to load chart data: {str(e)}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()