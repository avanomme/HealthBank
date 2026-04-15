# Created with the assistance of Generative AI
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent))
import json
import unittest
from datetime import date, datetime, time
from decimal import Decimal

from backend.app.utils.sanitize import sanitizeData, SanitizeConfig


class TestSanitizeData(unittest.TestCase):
    def test_primitives_passthrough(self):
        self.assertIsNone(sanitizeData(None))
        self.assertTrue(sanitizeData(True))
        self.assertFalse(sanitizeData(False))
        self.assertEqual(sanitizeData(123), 123)
        self.assertEqual(sanitizeData(3.5), 3.5)
        self.assertEqual(sanitizeData(Decimal("12.34")), Decimal("12.34"))

    def test_float_nan_inf_become_none_by_default(self):
        self.assertIsNone(sanitizeData(float("nan")))
        self.assertIsNone(sanitizeData(float("inf")))
        self.assertIsNone(sanitizeData(float("-inf")))

    def test_allow_nan_inf(self):
        cfg = SanitizeConfig(allow_nan_inf=True)

        out = sanitizeData(float("nan"), cfg)
        self.assertIsInstance(out, float)
        self.assertNotEqual(out, out)  # NaN != NaN

        self.assertEqual(sanitizeData(float("inf"), cfg), float("inf"))
        self.assertEqual(sanitizeData(float("-inf"), cfg), float("-inf"))

    def test_string_cleanup_trim_and_control_chars(self):
        s = "  hi\x00 there\x07  "
        self.assertEqual(sanitizeData(s), "hi there")

    def test_string_max_length(self):
        cfg = SanitizeConfig(max_string_length=5)
        self.assertEqual(sanitizeData("abcdef", cfg), "abcde")

    def test_bytes_base64_default(self):
        self.assertEqual(sanitizeData(b"hello"), "aGVsbG8=")

    def test_datetime_date_time_isoformat(self):
        self.assertEqual(sanitizeData(date(2026, 1, 27)), "2026-01-27")
        self.assertEqual(sanitizeData(time(12, 34, 56)), "12:34:56")
        self.assertEqual(
            sanitizeData(datetime(2026, 1, 27, 12, 34, 56)),
            "2026-01-27T12:34:56",
        )

    def test_complex_types_json_mode_default(self):
        payload = {"a": 1, "b": [" x ", b"hi"], 5: {"nested": "\x00ok"}}
        out = sanitizeData(payload)
        self.assertIsInstance(out, str)

        decoded = json.loads(out)
        self.assertEqual(decoded["a"], 1)
        self.assertEqual(decoded["b"][0], "x")
        self.assertEqual(decoded["b"][1], "aGk=")
        self.assertEqual(decoded["5"]["nested"], "ok")

    def test_complex_reject_mode(self):
        cfg = SanitizeConfig(complex_mode="reject", invalid_to_none=True)
        self.assertIsNone(sanitizeData({"a": 1}, cfg))
        self.assertIsNone(sanitizeData([1, 2, 3], cfg))


if __name__ == "__main__":
    unittest.main(verbosity=2)
