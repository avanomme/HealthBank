# Created with the Assistance of Claude Code
# backend/app/api/v1/templates.py
"""
Survey Templates CRUD API

Endpoints:
- POST   /api/v1/templates              - Create template
- GET    /api/v1/templates              - List all templates
- GET    /api/v1/templates/{id}         - Get single template
- PUT    /api/v1/templates/{id}         - Update template
- DELETE /api/v1/templates/{id}         - Delete template
- POST   /api/v1/templates/{id}/duplicate - Duplicate template

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, field_validator, Field
from typing import Optional, List
from datetime import datetime
from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string


class QuestionOptionInTemplate(BaseModel):
    option_id: int
    option_text: str
    display_order: int


router = APIRouter(dependencies=[Depends(require_role(2, 4))])


# Pydantic Models
class QuestionInTemplate(BaseModel):
    question_id: int
    title: Optional[str]
    question_content: str
    response_type: str
    is_required: bool
    display_order: int
    options: Optional[List[QuestionOptionInTemplate]] = None


class TemplateQuestionLinkCreate(BaseModel):
    question_id: int
    is_required: bool = False


class TemplateCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=2000)
    is_public: bool = False
    question_ids: Optional[List[int]] = None
    questions: Optional[List[TemplateQuestionLinkCreate]] = None

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


class TemplateUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    is_public: Optional[bool] = None
    question_ids: Optional[List[int]] = None
    questions: Optional[List[TemplateQuestionLinkCreate]] = None

    @field_validator('title', 'description', mode='before')
    @classmethod
    def sanitize_strings(cls, v):
        return sanitized_string(v)


class TemplateResponse(BaseModel):
    template_id: int
    title: str
    description: Optional[str]
    is_public: bool
    questions: Optional[List[QuestionInTemplate]] = None
    question_count: Optional[int] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None


# Helper functions
def get_template_questions(cursor, template_id: int) -> List[QuestionInTemplate]:
    """Fetch questions linked to a template with display order."""
    cursor.execute(
        """
        SELECT qb.QuestionID, qb.Title, qb.QuestionContent, qb.ResponseType,
               tq.IsRequired, tq.DisplayOrder
        FROM TemplateQuestions tq
        JOIN QuestionBank qb ON tq.QuestionID = qb.QuestionID
        WHERE tq.TemplateID = %s
        ORDER BY tq.DisplayOrder
        """,
        (template_id,)
    )
    rows = cursor.fetchall()

    questions = []
    for row in rows:
        question_id = row[0]
        response_type = row[3]

        # Get options for choice questions
        options = None
        if response_type in ['single_choice', 'multi_choice']:
            cursor.execute(
                "SELECT OptionID, OptionText, DisplayOrder FROM QuestionOptions WHERE QuestionID = %s ORDER BY DisplayOrder",
                (question_id,)
            )
            options = [QuestionOptionInTemplate(option_id=o[0], option_text=o[1], display_order=o[2]) for o in cursor.fetchall()]

        questions.append(QuestionInTemplate(
            question_id=question_id, title=row[1], question_content=row[2],
            response_type=response_type, is_required=bool(row[4]), display_order=row[5], options=options
        ))
    return questions


def normalize_template_questions(question_ids: Optional[List[int]], questions: Optional[List[TemplateQuestionLinkCreate]]):
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


def link_questions_to_template(cursor, template_id: int, questions: List[dict]):
    """Link questions to template with display order preserved."""
    for order, question in enumerate(questions):
        question_id = question["question_id"]
        is_required = question.get("is_required", False)

        cursor.execute("SELECT QuestionID FROM QuestionBank WHERE QuestionID = %s", (question_id,))
        if cursor.fetchone():
            cursor.execute(
                "INSERT INTO TemplateQuestions (TemplateID, QuestionID, IsRequired, DisplayOrder) VALUES (%s, %s, %s, %s)",
                (template_id, question_id, is_required, order)
            )


def unlink_all_template_questions(cursor, template_id: int):
    """Remove all question links for a template."""
    cursor.execute("DELETE FROM TemplateQuestions WHERE TemplateID = %s", (template_id,))


# Endpoints
@router.post("/", status_code=201)
async def create_template(
    template: TemplateCreate,
    current_user: dict = Depends(require_role(2, 4)),
) -> TemplateResponse:
    """Create a new survey template."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "INSERT INTO SurveyTemplate (Title, Description, IsPublic, CreatorID) VALUES (%s, %s, %s, %s)",
            (template.title, template.description, template.is_public, current_user["effective_account_id"])
        )
        conn.commit()
        template_id = cursor.lastrowid

        # Link questions if provided
        normalized_questions = normalize_template_questions(template.question_ids, template.questions)
        if normalized_questions:
            link_questions_to_template(cursor, template_id, normalized_questions)
            conn.commit()

        # Fetch created template
        cursor.execute(
            "SELECT TemplateID, Title, Description, IsPublic, CreatedAt, UpdatedAt FROM SurveyTemplate WHERE TemplateID = %s",
            (template_id,)
        )
        row = cursor.fetchone()
        questions = get_template_questions(cursor, template_id)

        return TemplateResponse(
            template_id=row[0], title=row[1], description=row[2], is_public=bool(row[3]),
            questions=questions, question_count=len(questions), created_at=row[4], updated_at=row[5]
        )
    finally:
        cursor.close()
        conn.close()


@router.get("/")
async def list_templates(
    is_public: Optional[bool] = Query(None),
    creator_id: Optional[int] = Query(None),
    limit: int = Query(500, ge=1, le=1000),
    offset: int = Query(0, ge=0),
) -> List[TemplateResponse]:
    """List all templates."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        query = "SELECT TemplateID, Title, Description, IsPublic, CreatedAt, UpdatedAt FROM SurveyTemplate WHERE 1=1"
        params = []

        if is_public is not None:
            query += " AND IsPublic = %s"
            params.append(is_public)

        if creator_id:
            query += " AND CreatorID = %s"
            params.append(creator_id)

        query += " ORDER BY CreatedAt DESC LIMIT %s OFFSET %s"
        params.extend([limit, offset])
        cursor.execute(query, tuple(params))
        rows = cursor.fetchall()

        templates = []
        for row in rows:
            template_id = row[0]
            cursor.execute("SELECT COUNT(*) FROM TemplateQuestions WHERE TemplateID = %s", (template_id,))
            question_count = cursor.fetchone()[0]

            templates.append(TemplateResponse(
                template_id=template_id, title=row[1], description=row[2], is_public=bool(row[3]),
                question_count=question_count, created_at=row[4], updated_at=row[5]
            ))
        return templates
    finally:
        cursor.close()
        conn.close()


@router.get("/{template_id}")
async def get_template(template_id: int) -> TemplateResponse:
    """Get a single template by ID with all questions."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT TemplateID, Title, Description, IsPublic, CreatedAt, UpdatedAt FROM SurveyTemplate WHERE TemplateID = %s",
            (template_id,)
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=404, detail="Template not found")

        questions = get_template_questions(cursor, template_id)

        return TemplateResponse(
            template_id=row[0], title=row[1], description=row[2], is_public=bool(row[3]),
            questions=questions, question_count=len(questions), created_at=row[4], updated_at=row[5]
        )
    finally:
        cursor.close()
        conn.close()


@router.put("/{template_id}")
async def update_template(template_id: int, template: TemplateUpdate) -> TemplateResponse:
    """Update an existing template."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT TemplateID FROM SurveyTemplate WHERE TemplateID = %s", (template_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Template not found")

        updates, params = [], []
        if template.title is not None:
            updates.append("Title = %s")
            params.append(template.title)
        if template.description is not None:
            updates.append("Description = %s")
            params.append(template.description)
        if template.is_public is not None:
            updates.append("IsPublic = %s")
            params.append(template.is_public)

        if updates:
            cursor.execute(f"UPDATE SurveyTemplate SET {', '.join(updates)} WHERE TemplateID = %s", tuple(params + [template_id]))
            conn.commit()

        # Update questions if provided
        normalized_questions = normalize_template_questions(template.question_ids, template.questions)
        if normalized_questions is not None:
            unlink_all_template_questions(cursor, template_id)
            if normalized_questions:
                link_questions_to_template(cursor, template_id, normalized_questions)
            conn.commit()

        # Fetch and return updated template
        cursor.execute(
            "SELECT TemplateID, Title, Description, IsPublic, CreatedAt, UpdatedAt FROM SurveyTemplate WHERE TemplateID = %s",
            (template_id,)
        )
        row = cursor.fetchone()
        questions = get_template_questions(cursor, template_id)

        return TemplateResponse(
            template_id=row[0], title=row[1], description=row[2], is_public=bool(row[3]),
            questions=questions, question_count=len(questions), created_at=row[4], updated_at=row[5]
        )
    finally:
        cursor.close()
        conn.close()


@router.delete("/{template_id}", status_code=204)
async def delete_template(template_id: int):
    """Delete a template. Questions remain in QuestionBank."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT TemplateID FROM SurveyTemplate WHERE TemplateID = %s", (template_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Template not found")

        # TemplateQuestions deleted via CASCADE
        cursor.execute("DELETE FROM SurveyTemplate WHERE TemplateID = %s", (template_id,))
        conn.commit()
        return None
    finally:
        cursor.close()
        conn.close()


@router.post("/{template_id}/duplicate", status_code=201)
async def duplicate_template(template_id: int) -> TemplateResponse:
    """Create a copy of an existing template with all its questions."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Get original template
        cursor.execute(
            "SELECT Title, Description FROM SurveyTemplate WHERE TemplateID = %s",
            (template_id,)
        )
        original = cursor.fetchone()

        if not original:
            raise HTTPException(status_code=404, detail="Template not found")

        # Create new template (always private)
        new_title = f"{original[0]} (Copy)"
        cursor.execute(
            "INSERT INTO SurveyTemplate (Title, Description, IsPublic) VALUES (%s, %s, %s)",
            (new_title, original[1], False)
        )
        conn.commit()
        new_template_id = cursor.lastrowid

        # Copy questions with order
        cursor.execute(
            "SELECT QuestionID, IsRequired, DisplayOrder FROM TemplateQuestions WHERE TemplateID = %s ORDER BY DisplayOrder",
            (template_id,)
        )
        for row in cursor.fetchall():
            cursor.execute(
                "INSERT INTO TemplateQuestions (TemplateID, QuestionID, IsRequired, DisplayOrder) VALUES (%s, %s, %s, %s)",
                (new_template_id, row[0], row[1], row[2])
            )
        conn.commit()

        # Return new template
        cursor.execute(
            "SELECT TemplateID, Title, Description, IsPublic, CreatedAt, UpdatedAt FROM SurveyTemplate WHERE TemplateID = %s",
            (new_template_id,)
        )
        row = cursor.fetchone()
        questions = get_template_questions(cursor, new_template_id)

        return TemplateResponse(
            template_id=row[0], title=row[1], description=row[2], is_public=bool(row[3]),
            questions=questions, question_count=len(questions), created_at=row[4], updated_at=row[5]
        )
    finally:
        cursor.close()
        conn.close()