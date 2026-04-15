# Created with the Assistance of Claude Code
"""Tests for app.services.translation module."""

import pytest
from unittest.mock import patch, MagicMock, call


class TestTranslateText:
    """Tests for translate_text()."""

    @patch("app.services.translation.GoogleTranslator")
    def test_translate_text_success(self, mock_translator_cls):
        from app.services.translation import translate_text

        mock_instance = MagicMock()
        mock_instance.translate.return_value = "Bonjour"
        mock_translator_cls.return_value = mock_instance

        result = translate_text("Hello", "fr")
        assert result == "Bonjour"
        mock_translator_cls.assert_called_once_with(source="en", target="fr")
        mock_instance.translate.assert_called_once_with("Hello")

    @patch("app.services.translation.GoogleTranslator")
    def test_translate_text_custom_source_lang(self, mock_translator_cls):
        from app.services.translation import translate_text

        mock_instance = MagicMock()
        mock_instance.translate.return_value = "Hello"
        mock_translator_cls.return_value = mock_instance

        result = translate_text("Bonjour", "en", source_lang="fr")
        assert result == "Hello"
        mock_translator_cls.assert_called_once_with(source="fr", target="en")

    @patch("app.services.translation.GoogleTranslator")
    def test_translate_text_empty_string(self, mock_translator_cls):
        from app.services.translation import translate_text

        result = translate_text("", "fr")
        assert result is None
        mock_translator_cls.assert_not_called()

    @patch("app.services.translation.GoogleTranslator")
    def test_translate_text_whitespace_only(self, mock_translator_cls):
        from app.services.translation import translate_text

        result = translate_text("   ", "fr")
        assert result is None
        mock_translator_cls.assert_not_called()

    @patch("app.services.translation.GoogleTranslator")
    def test_translate_text_none_input(self, mock_translator_cls):
        from app.services.translation import translate_text

        # text is None — `not text` is True
        result = translate_text(None, "fr")
        assert result is None

    @patch("app.services.translation.GoogleTranslator")
    def test_translate_text_exception_returns_none(self, mock_translator_cls):
        from app.services.translation import translate_text

        mock_instance = MagicMock()
        mock_instance.translate.side_effect = Exception("API error")
        mock_translator_cls.return_value = mock_instance

        result = translate_text("Hello", "fr")
        assert result is None


class TestTranslateQuestion:
    """Tests for translate_question()."""

    @patch("app.services.translation.translate_text")
    def test_translate_question_with_title(self, mock_translate):
        from app.services.translation import translate_question

        mock_translate.side_effect = lambda text, lang: f"{text}_fr"
        cursor = MagicMock()

        translate_question(cursor, 1, "My Title", "My Content")

        assert mock_translate.call_count == 2
        cursor.execute.assert_called_once()
        args = cursor.execute.call_args
        assert args[1] is None or len(args) == 2  # positional args
        params = args[0][1]
        assert params == (1, "fr", "My Title_fr", "My Content_fr")

    @patch("app.services.translation.translate_text")
    def test_translate_question_without_title(self, mock_translate):
        from app.services.translation import translate_question

        mock_translate.return_value = "Contenu traduit"
        cursor = MagicMock()

        translate_question(cursor, 5, None, "Some content")

        # Only content should be translated, not title
        mock_translate.assert_called_once_with("Some content", "fr")
        cursor.execute.assert_called_once()
        params = cursor.execute.call_args[0][1]
        assert params == (5, "fr", None, "Contenu traduit")

    @patch("app.services.translation.translate_text")
    def test_translate_question_content_fails_skips(self, mock_translate):
        from app.services.translation import translate_question

        # title translates, but content returns None
        mock_translate.side_effect = lambda text, lang: None
        cursor = MagicMock()

        translate_question(cursor, 1, "Title", "Content")

        # Should not execute INSERT because translated_content is None
        cursor.execute.assert_not_called()


class TestTranslateOptions:
    """Tests for translate_options()."""

    @patch("app.services.translation.translate_text")
    def test_translate_options_success(self, mock_translate):
        from app.services.translation import translate_options

        mock_translate.side_effect = lambda text, lang: f"{text}_fr"
        cursor = MagicMock()

        options = [(10, "Option A"), (11, "Option B")]
        translate_options(cursor, options)

        assert cursor.execute.call_count == 2
        # Check first call params
        params1 = cursor.execute.call_args_list[0][0][1]
        assert params1 == (10, "fr", "Option A_fr")
        params2 = cursor.execute.call_args_list[1][0][1]
        assert params2 == (11, "fr", "Option B_fr")

    @patch("app.services.translation.translate_text")
    def test_translate_options_translation_fails_skips(self, mock_translate):
        from app.services.translation import translate_options

        mock_translate.return_value = None
        cursor = MagicMock()

        options = [(10, "Option A")]
        translate_options(cursor, options)

        cursor.execute.assert_not_called()

    @patch("app.services.translation.translate_text")
    def test_translate_options_empty_list(self, mock_translate):
        from app.services.translation import translate_options

        cursor = MagicMock()
        translate_options(cursor, [])

        mock_translate.assert_not_called()
        cursor.execute.assert_not_called()


class TestGetTranslatedQuestion:
    """Tests for get_translated_question()."""

    def test_english_returns_none(self):
        from app.services.translation import get_translated_question

        cursor = MagicMock()
        result = get_translated_question(cursor, 1, "en")
        assert result is None
        cursor.execute.assert_not_called()

    def test_found_translation(self):
        from app.services.translation import get_translated_question

        cursor = MagicMock()
        cursor.fetchone.return_value = ("Titre", "Contenu de la question")

        result = get_translated_question(cursor, 1, "fr")

        cursor.execute.assert_called_once()
        params = cursor.execute.call_args[0][1]
        assert params == (1, "fr")
        assert result == {"title": "Titre", "question_content": "Contenu de la question"}

    def test_no_translation_returns_none(self):
        from app.services.translation import get_translated_question

        cursor = MagicMock()
        cursor.fetchone.return_value = None

        result = get_translated_question(cursor, 99, "fr")
        assert result is None


class TestGetTranslatedOptions:
    """Tests for get_translated_options()."""

    def test_english_returns_empty_dict(self):
        from app.services.translation import get_translated_options

        cursor = MagicMock()
        result = get_translated_options(cursor, 1, "en")
        assert result == {}
        cursor.execute.assert_not_called()

    def test_found_translations(self):
        from app.services.translation import get_translated_options

        cursor = MagicMock()
        cursor.fetchall.return_value = [(10, "Option A FR"), (11, "Option B FR")]

        result = get_translated_options(cursor, 1, "fr")

        cursor.execute.assert_called_once()
        params = cursor.execute.call_args[0][1]
        assert params == (1, "fr")
        assert result == {10: "Option A FR", 11: "Option B FR"}

    def test_no_translations_returns_empty_dict(self):
        from app.services.translation import get_translated_options

        cursor = MagicMock()
        cursor.fetchall.return_value = []

        result = get_translated_options(cursor, 1, "fr")
        assert result == {}
