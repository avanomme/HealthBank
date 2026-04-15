# Playwright Web Recording — Status & Resume Notes

## What Works
- Playwright + npm installed in `tools/demo-videos/playwright/`
- Flow entry updated to match the app: open `/`, then click the public `Log In` button
- `helpers.ts` activates Flutter semantics and fills Flutter web text inputs by
  matching visible label text ("Email", "Password", etc.) to the nearest
  underlying `input[data-semantics-role="text-field"]`
- Local API login works when Flutter web is built and served with:
  ```
  flutter build web --release --dart-define=API_BASE_URL=http://127.0.0.1:8000
  cd build/web && python3 -m http.server 62582
  ```
- Participant and researcher logins now reach their dashboards against the
  local backend
- Videos ARE being generated (`.webm` files appear in `output/web/` even on failure)

## Current State
- Playwright now targets the locally served built app on `http://localhost:62582`
- The built app is more reliable here than `flutter run -d web-server`
- Researcher/HCP/Admin logins are expected to reach their dashboards against the
  local API
- `/api/v1/sessions/me` now returns `needs_profile_completion: false` for
  `part@hb.com`, and the participant flow reaches `#/participant/dashboard`

## What To Try Next
1. Start the local backend if needed:
   ```
   make up
   ```
   or otherwise ensure `http://127.0.0.1:8000/health` returns 200.

2. Start the dedicated demo web server:
   ```
   make demo-web-server
   ```

3. Run a single login flow first:
   ```
   cd tools/demo-videos/playwright
   npx playwright test flows/03_login_researcher.spec.ts --reporter=list
   ```

4. Re-run participant after starting the new static server target:
   ```
   cd tools/demo-videos/playwright
   npx playwright test flows/02_login_participant.spec.ts --reporter=list
   ```

## Key File Locations
- Config: `tools/demo-videos/playwright/playwright.config.ts`
- Helpers: `tools/demo-videos/playwright/flows/helpers.ts`
- Flows: `tools/demo-videos/playwright/flows/0*.spec.ts`
- Output: `tools/demo-videos/output/web/`

## Port Note
This repo is now configured around `http://localhost:62582` for demo recording.
`make demo-web-server` builds the app and serves the static web output there.

## Inspect Script State
`inspect2.spec.ts` left in flows/ — can be used to dump DOM. Delete when done.
