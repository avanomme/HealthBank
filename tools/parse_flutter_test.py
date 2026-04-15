#!/usr/bin/env python3
"""
Parse flutter test --reporter json output.
Shows only failures with test name + truncated error, then a summary line.
Usage: flutter test --reporter json | python3 tools/parse_flutter_test.py
"""
import sys, json

tests = {}      # id -> name
failures = []   # list of (name, error)
passed = 0
skipped = 0

for raw in sys.stdin:
    raw = raw.strip()
    if not raw:
        continue
    try:
        e = json.loads(raw)
    except json.JSONDecodeError:
        continue

    t = e.get("type", "")

    if t == "testStart":
        info = e.get("test", {})
        tests[info.get("id")] = info.get("name", "?")

    elif t == "error":
        name = tests.get(e.get("testID"), "unknown test")
        err  = e.get("error", "").split("\n")[0][:200]  # first line, max 200 chars
        failures.append((name, err))

    elif t == "testDone":
        result = e.get("result", "")
        if result == "success" and not e.get("skipped"):
            passed += 1
        elif e.get("skipped"):
            skipped += 1

    elif t == "done":
        total = e.get("count", passed + len(failures))
        success = e.get("success", not failures)

        if failures:
            print(f"\n\033[31m── {len(failures)} FAILURE(S) ─────────────────────────────────────────\033[0m")
            for name, err in failures:
                print(f"\033[31m✗ {name}\033[0m")
                print(f"  {err}")
        else:
            print(f"\n\033[32m── All tests passed ────────────────────────────────────────────\033[0m")

        status = "\033[32mPASSED\033[0m" if success else "\033[31mFAILED\033[0m"
        print(f"\n{status}: {passed} passed, {len(failures)} failed, {skipped} skipped  ({total} total)\n")
        sys.exit(0 if success else 1)
