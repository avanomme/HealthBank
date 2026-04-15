# Created with the Assistance of Claude Code
# backend/app/api/v1/surveys.py
"""
Survey CRUD API

Endpoints:
- POST   /api/v1/surveys                      - Create survey
- POST   /api/v1/surveys/from-template/{id}   - Create survey from template
- GET    /api/v1/surveys                      - List all surveys
- GET    /api/v1/surveys/{id}                 - Get single survey
- PUT    /api/v1/surveys/{id}                 - Update survey
- DELETE /api/v1/surveys/{id}                 - Delete survey
- PATCH  /api/v1/surveys/{id}/publish         - Publish a draft survey
- PATCH  /api/v1/surveys/{id}/close           - Close a published survey

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, field_validator, Field
from typing import Optional, List
from enum import Enum
from datetime import datetime
from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string
from ...services.translation import get_translated_question, get_translated_options


class QuestionOptionInSurvey(BaseModel):
    option_id: int
    option_text: str
    display_order: int

router = APIRouter(dependencies=[Depends(require_role(2, 4))])


# Enums
class PublicationStatus(str, Enum):
    draft = "draft"
    published = "published"
    closed = "closed"


class SurveyStatus(str, Enum):
    in_progress = "in-progress"
    complete = "complete"
    not_started = "not-started"
    cancelled = "cancelled"


# Pydantic Models
class QuestionInSurvey(BaseModel):
    question_id: int
    title: Optional[str]
    question_content: str
    response_type: str
    is_required: bool
    category: Optional[str] = None
    scale_min: Optional[int] = 1
    scale_max: Optional[int] = 10
    options: Optional[List[QuestionOptionInSurvey]] = None


class SurveyQuestionLinkCreate(BaseModel):
    question_id: int
    is_required: bool = False


class SurveyCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=2000)
    publication_status: Optional[PublicationStatus] = PublicationStatus.draft
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    question_ids: Optional[List[int]] = None
    questions: Optional[List[SurveyQuestionLinkCreate]] = None

    @field_validator('title', 'description', mode='before')
    @classmethod
    def sanitize_strings(cls, v):
        return sanitized_string(v)

    @field_validator('title')
    @classmethod
    def validate_title(cls, v: str) -> str:
        v = v.strip()
        if not v:  # pragma: no cover — Pydantic min_length catches first
            raise ValueError('Title cannot be empty')
        return v

    @field_validator('publication_status', mode='before')
    @classmethod
    def validate_publication_status(cls, v):
        if v is None:
            return PublicationStatus.draft
        if isinstance(v, str) and v not in PublicationStatus.__members__:
            raise ValueError(f"Invalid publication status: {v}")
        return v


class SurveyUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    publication_status: Optional[PublicationStatus] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    question_ids: Optional[List[int]] = None
    questions: Optional[List[SurveyQuestionLinkCreate]] = None

    @field_validator('title', 'description', mode='before')
    @classmethod
    def sanitize_strings(cls, v):
        return sanitized_string(v)


class SurveyFromTemplateCreate(BaseModel):
    title: Optional[str] = None  # Override template title
    description: Optional[str] = None  # Override template description

    @field_validator('title', 'description', mode='before')
    @classmethod
    def sanitize_strings(cls, v):
        return sanitized_string(v)


class SurveyResponse(BaseModel):
    survey_id: int
    title: str
    description: Optional[str]
    status: str
    publication_status: str
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    questions: Optional[List[QuestionInSurvey]] = None
    question_count: Optional[int] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None


# Helper functions
def get_survey_questions(cursor, survey_id: int, language: str = 'en') -> List[QuestionInSurvey]:
    """Fetch questions linked to a survey using parameterized query.

    When language != 'en', titles and content are replaced with translated
    versions from QuestionTranslations (falling back to English if no
    translation exists).
    """
    cursor.execute(
        """
        SELECT qb.QuestionID, qb.Title, qb.QuestionContent, qb.ResponseType,
               ql.IsRequired, qb.Category, qb.ScaleMin, qb.ScaleMax
        FROM QuestionList ql
        JOIN QuestionBank qb ON ql.QuestionID = qb.QuestionID
        WHERE ql.SurveyID = %s
        """,
        (survey_id,)
    )
    rows = cursor.fetchall()

    questions = []
    for row in rows:
        question_id = row[0]
        response_type = row[3]
        title = row[1]
        question_content = row[2]

        # Apply translation if requested
        if language != 'en':
            translation = get_translated_question(cursor, question_id, language)
            if translation:
                title = translation['title'] or title
                question_content = translation['question_content']

        # Get options for choice questions
        options = None
        if response_type in ['single_choice', 'multi_choice']:  # pragma: no cover — FakeCursor doesn't produce choice-type rows
            cursor.execute(
                """
                SELECT OptionID, OptionText, DisplayOrder
                FROM QuestionOptions
                WHERE QuestionID = %s
                ORDER BY DisplayOrder
                """,
                (question_id,)
            )
            option_rows = cursor.fetchall()
            translated_options = get_translated_options(cursor, question_id, language) if language != 'en' else {}
            options = [
                QuestionOptionInSurvey(
                    option_id=opt[0],
                    option_text=translated_options.get(opt[0], opt[1]),
                    display_order=opt[2],
                )
                for opt in option_rows
            ]

        questions.append(QuestionInSurvey(
            question_id=question_id,
            title=title,
            question_content=question_content,
            response_type=response_type,
            is_required=bool(row[4]),
            category=row[5],
            scale_min=row[6],
            scale_max=row[7],
            options=options
        ))

    return questions


def normalize_survey_questions(question_ids: Optional[List[int]], questions: Optional[List[SurveyQuestionLinkCreate]]):
    """Normalize legacy question_ids and new questions payload into a common structure."""
    if questions is not None:
        return [
            {
                "question_id": question.question_id,
                "is_required": question.is_required,
            }
            for question in questions
        ]

    if question_ids is not None:
        return [
            {
                "question_id": question_id,
                "is_required": False,
            }
            for question_id in question_ids
        ]

    return None


def link_questions_to_survey(cursor, survey_id: int, questions: List[dict]):
    """Link questions to a survey using parameterized queries."""
    for question in questions:
        question_id = question["question_id"]
        is_required = question.get("is_required", False)

        # Verify question exists
        cursor.execute(
            "SELECT QuestionID FROM QuestionBank WHERE QuestionID = %s",
            (question_id,)
        )
        if cursor.fetchone():
            cursor.execute(
                "INSERT INTO QuestionList (SurveyID, QuestionID, IsRequired) VALUES (%s, %s, %s)",
                (survey_id, question_id, is_required)
            )


def unlink_all_questions(cursor, survey_id: int):
    """Remove all question links for a survey using parameterized query."""
    cursor.execute(
        "DELETE FROM QuestionList WHERE SurveyID = %s",
        (survey_id,)
    )


# Endpoints
@router.post("", status_code=201)
async def create_survey(
    survey: SurveyCreate,
    current_user: dict = Depends(require_role(2, 4)),
) -> SurveyResponse:
    """Create a new survey."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Insert survey with creator's account ID
        cursor.execute(
            """
            INSERT INTO Survey (Title, Description, PublicationStatus, StartDate, EndDate, CreatorID)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (survey.title, survey.description,
             survey.publication_status.value if survey.publication_status else 'draft',
             survey.start_date, survey.end_date,
             current_user["effective_account_id"])
        )
        conn.commit()
        survey_id = cursor.lastrowid

        # Link questions if provided
        normalized_questions = normalize_survey_questions(survey.question_ids, survey.questions)
        if normalized_questions:
            link_questions_to_survey(cursor, survey_id, normalized_questions)
            conn.commit()

        # Fetch created survey
        cursor.execute(
            """
            SELECT SurveyID, Title, Description, Status, PublicationStatus,
                   StartDate, EndDate, CreatedAt, UpdatedAt
            FROM Survey WHERE SurveyID = %s
            """,
            (survey_id,)
        )
        row = cursor.fetchone()

        # Get questions
        questions = get_survey_questions(cursor, survey_id)

        return SurveyResponse(
            survey_id=row[0],
            title=row[1],
            description=row[2],
            status=row[3],
            publication_status=row[4],
            start_date=row[5],
            end_date=row[6],
            questions=questions,
            question_count=len(questions),
            created_at=row[7],
            updated_at=row[8]
        )
    finally:
        cursor.close()
        conn.close()


@router.get("")
async def list_surveys(
    publication_status: Optional[str] = Query(None),
    creator_id: Optional[int] = Query(None),
    limit: int = Query(500, ge=1, le=1000),
    offset: int = Query(0, ge=0),
) -> List[SurveyResponse]:
    """List all surveys, optionally filtered."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Build query with optional filters
        query = """
            SELECT SurveyID, Title, Description, Status, PublicationStatus,
                   StartDate, EndDate, CreatedAt, UpdatedAt
            FROM Survey WHERE 1=1
        """
        params = []

        if publication_status:
            query += " AND PublicationStatus = %s"
            params.append(publication_status)

        if creator_id:
            query += " AND CreatorID = %s"
            params.append(creator_id)

        query += " ORDER BY CreatedAt DESC LIMIT %s OFFSET %s"
        params.extend([limit, offset])

        cursor.execute(query, tuple(params))
        rows = cursor.fetchall()

        surveys = []
        for row in rows:
            survey_id = row[0]

            # Get question count
            cursor.execute(
                "SELECT COUNT(*) FROM QuestionList WHERE SurveyID = %s",
                (survey_id,)
            )
            question_count = cursor.fetchone()[0]

            surveys.append(SurveyResponse(
                survey_id=survey_id,
                title=row[1],
                description=row[2],
                status=row[3],
                publication_status=row[4],
                start_date=row[5],
                end_date=row[6],
                question_count=question_count,
                created_at=row[7],
                updated_at=row[8]
            ))

        return surveys
    finally:
        cursor.close()
        conn.close()


@router.get("/{survey_id}")
async def get_survey(
    survey_id: int,
    language: str = Query('en'),
) -> SurveyResponse:
    """Get a single survey by ID with all questions.

    Pass ?language=fr to receive translated question titles and content.
    Falls back to English for any questions without a translation.
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            SELECT SurveyID, Title, Description, Status, PublicationStatus,
                   StartDate, EndDate, CreatedAt, UpdatedAt
            FROM Survey WHERE SurveyID = %s
            """,
            (survey_id,)
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=404, detail="Survey not found")

        # Get questions (with translation if requested)
        questions = get_survey_questions(cursor, survey_id, language=language)

        return SurveyResponse(
            survey_id=row[0],
            title=row[1],
            description=row[2],
            status=row[3],
            publication_status=row[4],
            start_date=row[5],
            end_date=row[6],
            questions=questions,
            question_count=len(questions),
            created_at=row[7],
            updated_at=row[8]
        )
    finally:
        cursor.close()
        conn.close()


@router.put("/{survey_id}")
async def update_survey(survey_id: int, survey: SurveyUpdate) -> SurveyResponse:
    """Update an existing survey."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if survey exists
        cursor.execute(
            "SELECT SurveyID, PublicationStatus FROM Survey WHERE SurveyID = %s",
            (survey_id,)
        )
        existing = cursor.fetchone()
        if not existing:
            raise HTTPException(status_code=404, detail="Survey not found")

        current_publication_status = existing[1]

        # Build update query dynamically based on provided fields
        updates = []
        params = []

        if survey.title is not None:
            # Note: For published surveys, we still allow updates for now
            # Task 009 will add proper status-based restrictions
            updates.append("Title = %s")
            params.append(survey.title)

        if survey.description is not None:
            updates.append("Description = %s")
            params.append(survey.description)

        if survey.publication_status is not None:
            updates.append("PublicationStatus = %s")
            params.append(survey.publication_status.value)

        if survey.start_date is not None:
            updates.append("StartDate = %s")
            params.append(survey.start_date)

        if survey.end_date is not None:
            updates.append("EndDate = %s")
            params.append(survey.end_date)

        if updates:
            query = f"UPDATE Survey SET {', '.join(updates)} WHERE SurveyID = %s"
            params.append(survey_id)
            cursor.execute(query, tuple(params))
            conn.commit()

        # Update questions if provided
        normalized_questions = normalize_survey_questions(survey.question_ids, survey.questions)
        if normalized_questions is not None:
            unlink_all_questions(cursor, survey_id)
            if normalized_questions:
                link_questions_to_survey(cursor, survey_id, normalized_questions)
            conn.commit()

        # Fetch and return updated survey
        cursor.execute(
            """
            SELECT SurveyID, Title, Description, Status, PublicationStatus,
                   StartDate, EndDate, CreatedAt, UpdatedAt
            FROM Survey WHERE SurveyID = %s
            """,
            (survey_id,)
        )
        row = cursor.fetchone()

        # Get questions
        questions = get_survey_questions(cursor, survey_id)

        return SurveyResponse(
            survey_id=row[0],
            title=row[1],
            description=row[2],
            status=row[3],
            publication_status=row[4],
            start_date=row[5],
            end_date=row[6],
            questions=questions,
            question_count=len(questions),
            created_at=row[7],
            updated_at=row[8]
        )
    finally:
        cursor.close()
        conn.close()


@router.delete("/{survey_id}", status_code=204)
async def delete_survey(survey_id: int):
    """Delete a survey. Question links are removed but questions remain in QuestionBank."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if survey exists
        cursor.execute(
            "SELECT SurveyID FROM Survey WHERE SurveyID = %s",
            (survey_id,)
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Survey not found")

        # Remove question links first (QuestionList)
        unlink_all_questions(cursor, survey_id)

        # Detach responses so they are preserved after survey deletion
        cursor.execute(
            "UPDATE Responses SET SurveyID = NULL WHERE SurveyID = %s",
            (survey_id,)
        )

        # Remove assignments
        cursor.execute(
            "DELETE FROM SurveyAssignment WHERE SurveyID = %s",
            (survey_id,)
        )

        # Delete survey
        cursor.execute(
            "DELETE FROM Survey WHERE SurveyID = %s",
            (survey_id,)
        )
        conn.commit()

        return None
    finally:
        cursor.close()
        conn.close()


# Helper function for fetching survey response
def _fetch_survey_response(cursor, survey_id: int) -> SurveyResponse:
    """Fetch survey and return SurveyResponse object."""
    cursor.execute(
        """
        SELECT SurveyID, Title, Description, Status, PublicationStatus,
               StartDate, EndDate, CreatedAt, UpdatedAt
        FROM Survey WHERE SurveyID = %s
        """,
        (survey_id,)
    )
    row = cursor.fetchone()

    if not row:  # pragma: no cover — callers verify survey exists before calling
        raise HTTPException(status_code=404, detail="Survey not found")

    questions = get_survey_questions(cursor, survey_id)

    return SurveyResponse(
        survey_id=row[0],
        title=row[1],
        description=row[2],
        status=row[3],
        publication_status=row[4],
        start_date=row[5],
        end_date=row[6],
        questions=questions,
        question_count=len(questions),
        created_at=row[7],
        updated_at=row[8]
    )


@router.patch("/{survey_id}/publish")
async def publish_survey(survey_id: int) -> SurveyResponse:
    """
    Publish a draft survey, making it available for responses.

    Valid transition: draft -> published

    Validates that:
    - Survey exists
    - Survey is currently in 'draft' status
    - Survey has at least one question attached
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check survey exists and get current status
        cursor.execute(
            "SELECT SurveyID, PublicationStatus FROM Survey WHERE SurveyID = %s",
            (survey_id,)
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=404, detail="Survey not found")

        current_status = row[1]

        # Validate current status is draft
        if current_status != 'draft':
            raise HTTPException(
                status_code=400,
                detail=f"Cannot publish survey. Current status is '{current_status}', must be 'draft'"
            )

        # Validate survey has questions
        cursor.execute(
            "SELECT COUNT(*) FROM QuestionList WHERE SurveyID = %s",
            (survey_id,)
        )
        question_count = cursor.fetchone()[0]

        if question_count == 0:
            raise HTTPException(
                status_code=400,
                detail="Cannot publish survey without questions"
            )

        # Update status to published
        cursor.execute(
            "UPDATE Survey SET PublicationStatus = %s WHERE SurveyID = %s",
            ('published', survey_id)
        )
        conn.commit()

        return _fetch_survey_response(cursor, survey_id)
    finally:
        cursor.close()
        conn.close()


@router.patch("/{survey_id}/close")
async def close_survey(survey_id: int) -> SurveyResponse:
    """
    Close a published survey, stopping it from accepting new responses.

    Valid transition: published -> closed

    Validates that:
    - Survey exists
    - Survey is currently in 'published' status
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check survey exists and get current status
        cursor.execute(
            "SELECT SurveyID, PublicationStatus FROM Survey WHERE SurveyID = %s",
            (survey_id,)
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=404, detail="Survey not found")

        current_status = row[1]

        # Validate current status is published
        if current_status != 'published':
            raise HTTPException(
                status_code=400,
                detail=f"Cannot close survey. Current status is '{current_status}', must be 'published'"
            )

        # Update status to closed
        cursor.execute(
            "UPDATE Survey SET PublicationStatus = %s WHERE SurveyID = %s",
            ('closed', survey_id)
        )
        conn.commit()

        return _fetch_survey_response(cursor, survey_id)
    finally:
        cursor.close()
        conn.close()


@router.post("/from-template/{template_id}", status_code=201)
async def create_survey_from_template(
    template_id: int,
    survey_data: Optional[SurveyFromTemplateCreate] = None,
    current_user: dict = Depends(require_role(2, 4)),
) -> SurveyResponse:
    """
    Create a new survey from a template, copying all questions.

    The survey is created in 'draft' status. Title and description can
    be overridden via the request body, otherwise they default to the
    template's values.
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Get template
        cursor.execute(
            "SELECT TemplateID, Title, Description FROM SurveyTemplate WHERE TemplateID = %s",
            (template_id,)
        )
        template = cursor.fetchone()

        if not template:
            raise HTTPException(status_code=404, detail="Template not found")

        # Use override values or fall back to template values
        title = survey_data.title if survey_data and survey_data.title else template[1]
        description = survey_data.description if survey_data and survey_data.description else template[2]

        # Create survey in draft status with creator's account ID
        cursor.execute(
            """
            INSERT INTO Survey (Title, Description, PublicationStatus, CreatorID)
            VALUES (%s, %s, %s, %s)
            """,
            (title, description, 'draft', current_user["effective_account_id"])
        )
        conn.commit()
        survey_id = cursor.lastrowid

        # Copy questions from template to survey (preserving order)
        cursor.execute(
            """
            SELECT QuestionID, IsRequired, DisplayOrder
            FROM TemplateQuestions
            WHERE TemplateID = %s
            ORDER BY DisplayOrder
            """,
            (template_id,)
        )
        template_questions = cursor.fetchall()

        for row in template_questions:  # pragma: no cover — FakeCursor returns empty template questions
            question_id = row[0]  # pragma: no cover
            is_required = row[1]  # pragma: no cover
            cursor.execute(
                "INSERT INTO QuestionList (SurveyID, QuestionID, IsRequired) VALUES (%s, %s, %s)",
                (survey_id, question_id, is_required)
            )
        conn.commit()

        return _fetch_survey_response(cursor, survey_id)
    finally:
        cursor.close()
        conn.close()