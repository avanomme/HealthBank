# Created with the Assistance of Claude Code
"""
Automatic translation service for survey questions and options.

Translates question content into all supported languages when questions
are created or updated. Uses Google Translate (free) via deep-translator.

Supported languages are configured in SUPPORTED_LANGUAGES. English ('en')
is treated as the source language.
"""
from __future__ import annotations

import logging
from typing import Optional

from deep_translator import GoogleTranslator

logger = logging.getLogger(__name__)

# Languages to auto-translate into (excluding 'en' which is the source).
# Add new language codes here as needed (e.g. 'es', 'de', 'ar').
SUPPORTED_LANGUAGES = ["fr"]


def translate_text(text: str, target_lang: str, source_lang: str = "en") -> Optional[str]:
    """Translate a single string. Returns None on failure (best-effort)."""
    if not text or not text.strip():
        return None
    try:
        result = GoogleTranslator(source=source_lang, target=target_lang).translate(text)
        return result
    except Exception as e:
        logger.warning("Translation failed (%s→%s): %s", source_lang, target_lang, e)
        return None


def translate_question(cursor, question_id: int, title: Optional[str], content: str) -> None:
    """Translate a question's title and content into all supported languages."""
    for lang in SUPPORTED_LANGUAGES:
        translated_title = translate_text(title, lang) if title else None
        translated_content = translate_text(content, lang)
        if translated_content is None:
            continue

        cursor.execute(
            """
            INSERT INTO QuestionTranslations (QuestionID, LanguageCode, Title, QuestionContent)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE Title = VALUES(Title), QuestionContent = VALUES(QuestionContent)
            """,
            (question_id, lang, translated_title, translated_content),
        )


def translate_options(cursor, options: list[tuple[int, str]]) -> None:
    """Translate option texts. options = [(option_id, option_text), ...]."""
    for lang in SUPPORTED_LANGUAGES:
        for option_id, option_text in options:
            translated = translate_text(option_text, lang)
            if translated is None:
                continue

            cursor.execute(
                """
                INSERT INTO QuestionOptionTranslations (OptionID, LanguageCode, OptionText)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE OptionText = VALUES(OptionText)
                """,
                (option_id, lang, translated),
            )


def get_translated_question(cursor, question_id: int, lang: str) -> Optional[dict]:
    """Get translated title/content for a question, or None if not available."""
    if lang == "en":
        return None
    cursor.execute(
        "SELECT Title, QuestionContent FROM QuestionTranslations WHERE QuestionID = %s AND LanguageCode = %s",
        (question_id, lang),
    )
    row = cursor.fetchone()
    if row:
        return {"title": row[0], "question_content": row[1]}
    return None


def get_translated_options(cursor, question_id: int, lang: str) -> dict[int, str]:
    """Get translated option texts keyed by OptionID, or empty dict."""
    if lang == "en":
        return {}
    cursor.execute(
        """
        SELECT qot.OptionID, qot.OptionText
        FROM QuestionOptionTranslations qot
        JOIN QuestionOptions qo ON qo.OptionID = qot.OptionID
        WHERE qo.QuestionID = %s AND qot.LanguageCode = %s
        """,
        (question_id, lang),
    )
    return {int(r[0]): r[1] for r in cursor.fetchall()}
