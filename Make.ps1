# Created with the Assistance of Claude Code
# This file was composed with help from GH Co-Pilot

param(
    [Parameter(Position = 0)]
    [string]$Target = "help"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$FRONTEND_DIR = "frontend"
$LOCAL_URL = "http://localhost:3000"
$SERVER_URL = "http://137.149.157.193:3000"
$ANDROID_LOCAL_URL = "http://10.0.2.2:3000"
$FLUTTER_DEVICE = if ($env:FLUTTER_DEVICE) { $env:FLUTTER_DEVICE } else { "chrome" }
$API_BASE_URL = if ($env:API_BASE_URL) { $env:API_BASE_URL } else { "http://127.0.0.1:8000" }
$isWindowsOs = $env:OS -eq "Windows_NT"
$BRAVE_BIN = if ($isWindowsOs) {
    "$env:ProgramFiles\BraveSoftware\Brave-Browser\Application\brave.exe"
} else {
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
}

$TargetDescriptions = [ordered]@{
    "up" = "Start containers"
    "front" = "Build Flutter web locally and hot-swap into nginx volume (~45s)"
    "front-new" = "Full Docker frontend rebuild"
    "api" = "Rebuild API only and restart nginx"
    "nginx" = "Rebuild nginx only"
    "db" = "Recreate and reseed database"
    "wait-api" = "Wait until API responds with 200 OK"
    "build" = "Build images"
    "logs" = "Follow API logs"
    "test" = "Run backend + frontend tests"
    "test-backend" = "Run backend pytest tests"
    "test-integration" = "Run integration tests"
    "test-frontend" = "Run frontend Flutter tests (shows failures clearly)"
    "test-file"     = "Run one test file: .\Make.ps1 test-file FILE=test/path/test.dart"
    "down" = "Stop and remove containers"
    "clean" = "Stop containers and remove leftover resources"
    "db-seed" = "Drop, recreate, and reseed database"
    "db-reset" = "Reset database schema only"
    "db-migrate" = "Apply SQL migration files locally"
    "db-migrate-remote" = "Apply SQL migrations on remote host"
    "db-nuke" = "Remove DB volume and restart mysql"
    "api-restart" = "Restart API container (no rebuild)"
    "docker" = "Smart rebuild — only rebuilds services whose files changed"
    "docker-frontend" = "Rebuild frontend only (keeps pub cache)"
    "docker-local-build" = "Build Flutter locally and serve through nginx"
    "docker-local-refresh" = "Refresh nginx volume with local Flutter build"
    "server-up" = "Start server profile compose stack"
    "server-down" = "Stop server profile compose stack"
    "server-restart" = "Rebuild/restart API for server profile"
    "docker-new" = "Full rebuild — fresh DB, layer cache preserved"
    "docker-purge" = "NUCLEAR — wipe everything including base images and caches"
    "docker-dev" = "Start MySQL/API/nginx with dev compose overrides"
    "docker-dev-new" = "No-cache rebuild for dev compose with fresh DB"
    "docker-back" = "Start backend only with dev compose"
    "flutter" = "Run Flutter in Chrome against local URL"
    "flutter-server" = "Run Flutter in Chrome against server URL"
    "flutter-brave" = "Run Flutter in Brave against local URL"
    "flutter-prod" = "Run Flutter in release mode against local URL"
    "mobile" = "Build both iOS and Android release -> UPEI server"
    "android" = "Build Android release APK -> UPEI server"
    "android-dev" = "Run Flutter debug on connected Android -> UPEI server"
    "android-local" = "Run Flutter debug on connected Android -> local Docker"
    "ios" = "Build iOS release -> UPEI server (signed with your LocalSigning.xcconfig team)"
    "ios-dev" = "Run Flutter on iOS device/simulator -> UPEI server"
    "ios-local" = "Run Flutter on iOS -> local Docker"
    "ios-altstore" = "Build iOS release and package IPA for AltStore sideloading"
    "phone" = "Install release APK on connected Android device"
    "iPhone" = "Install iOS build on connected iPhone"
    "iPad" = "Install iOS build on connected iPad"
    "deploy" = "Build Flutter locally and push to server nginx volume"
    "deploy-api" = "Push backend changes to server and rebuild API"
    "demo-install" = "Install demo video tools (Playwright) — run once"
    "demo-web-server" = "Build Flutter web for demo recording and serve on :62582"
    "demo-web-resumable" = "Record all web videos with resumable checkpoints"
    "demo-web-resumable-reset" = "Wipe checkpoint and re-record all web videos from scratch"
    "demo-web-export" = "Re-export/rename already-recorded MP4s without re-running Playwright"
    "playwright" = "Orchestrate full Playwright recording + MP4 export to ./videos"
    "playwright-track" = "Follow live Playwright recording and demo-server logs"
    "patrol-install" = "Install Patrol CLI for mobile integration testing"
    "patrol-android" = "Run integration test (overflow scan) on Android emulator"
    "dev" = "Run table widget preview with mock API"
    "list" = "List all available commands"
    "help" = "Alias for list"
}

function Invoke-External {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,
        [switch]$IgnoreError
    )

    Write-Host "> $Command" -ForegroundColor DarkGray
    & powershell -NoProfile -ExecutionPolicy Bypass -Command $Command
    if (-not $IgnoreError -and $LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $Command"
    }
}

function Invoke-Compose {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args,
        [switch]$IgnoreError
    )

    & docker compose @Args
    if (-not $IgnoreError -and $LASTEXITCODE -ne 0) {
        $joined = $Args -join " "
        throw "docker compose $joined failed with exit code $LASTEXITCODE"
    }
}

function Invoke-ComposeDev {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args,
        [switch]$IgnoreError
    )

    & docker compose -f docker-compose.yml -f docker-compose.dev.yml @Args
    if (-not $IgnoreError -and $LASTEXITCODE -ne 0) {
        $joined = $Args -join " "
        throw "docker compose (dev) $joined failed with exit code $LASTEXITCODE"
    }
}

function Invoke-ComposeServer {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args,
        [switch]$IgnoreError
    )

    & docker compose -f docker-compose.yml -f docker-compose.server.yml @Args
    if (-not $IgnoreError -and $LASTEXITCODE -ne 0) {
        $joined = $Args -join " "
        throw "docker compose (server) $joined failed with exit code $LASTEXITCODE"
    }
}

function Invoke-InFrontend {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Script
    )

    Push-Location $FRONTEND_DIR
    try {
        & $Script
    }
    finally {
        Pop-Location
    }
}

function Invoke-Up {
    Invoke-Compose -Args @("up", "-d")
}

function Invoke-Front {
    Write-Host "Building Flutter web locally..." -ForegroundColor Cyan
    Invoke-InFrontend {
        & flutter build web --release
        if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" }
    }

    Write-Host "Copying build to nginx volume..." -ForegroundColor Cyan
    $source = "${PWD}\$FRONTEND_DIR\build\web"
    & docker run --rm -v healthbank_frontend_build:/output -v "${source}:/src:ro" alpine sh -c "rm -rf /output/* && cp -r /src/* /output/"
    if ($LASTEXITCODE -ne 0) { throw "Failed to copy local web build into Docker volume" }

    Write-Host "Done. Hard-refresh browser (Ctrl+Shift+R)." -ForegroundColor Green
}

function Invoke-FrontNew {
    Write-Host "Rebuilding frontend Docker image..." -ForegroundColor Cyan
    Invoke-Compose -Args @("stop", "frontend", "nginx") -IgnoreError
    Invoke-Compose -Args @("rm", "-f", "frontend", "nginx") -IgnoreError
    & docker volume rm -f healthbank_frontend_build 2>$null | Out-Null
    Invoke-Compose -Args @("build", "frontend")
    Invoke-Compose -Args @("up", "-d", "--no-deps", "frontend")
    & docker wait hdb-frontend-build 2>$null | Out-Null
    Invoke-Compose -Args @("up", "-d", "--no-deps", "nginx")
    Write-Host "Done. Hard-refresh browser (Ctrl+Shift+R)." -ForegroundColor Green
}

function Invoke-Api {
    Write-Host "Rebuilding API..." -ForegroundColor Cyan
    Invoke-Compose -Args @("build", "api")
    Invoke-Compose -Args @("up", "-d", "--force-recreate", "--no-deps", "api")
    Invoke-Compose -Args @("restart", "nginx")
}

function Invoke-Nginx {
    Write-Host "Rebuilding nginx..." -ForegroundColor Cyan
    Invoke-Compose -Args @("build", "nginx")
    Invoke-Compose -Args @("up", "-d", "--force-recreate", "--no-deps", "nginx")
}

function Invoke-Db {
    Write-Host "Stopping API to avoid stale connections..." -ForegroundColor Cyan
    Invoke-Compose -Args @("stop", "api") -IgnoreError

    Write-Host "Dropping and recreating database..." -ForegroundColor Cyan
    Invoke-External -Command "docker compose exec mysql mysql -u root -ppassword -e \"DROP DATABASE IF EXISTS healthdatabase; CREATE DATABASE healthdatabase;\""
    Invoke-External -Command "Get-Content -Raw database/init/01_create_database.sql | docker compose exec -T mysql mysql -u root -ppassword healthdatabase"
    Invoke-External -Command "Get-Content -Raw database/init/02_survey_seed_data.sql | docker compose exec -T mysql mysql -u root -ppassword healthdatabase"

    Invoke-Compose -Args @("up", "-d", "--no-deps", "api")
    Write-Host "Done." -ForegroundColor Green
}

function Invoke-WaitApi {
    Write-Host "Waiting for API to be ready..." -ForegroundColor Cyan
    $maxAttempts = 60
    for ($i = 0; $i -lt $maxAttempts; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://127.0.0.1:8000/health" -Method GET -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Host "API is ready" -ForegroundColor Green
                return
            }
        }
        catch {
            # Retry
        }
        Start-Sleep -Seconds 2
    }

    throw "API not ready after timeout"
}

function Invoke-Build {
    Invoke-Compose -Args @("build")
}

function Invoke-Logs {
    Invoke-Compose -Args @("logs", "-f", "api")
}

function Invoke-Test {
    Invoke-Up
    Invoke-WaitApi
    Write-Host "Running backend tests..." -ForegroundColor Cyan
    & python -m pytest -v
    if ($LASTEXITCODE -ne 0) { throw "Backend tests failed" }

    Write-Host "Running frontend tests..." -ForegroundColor Cyan
    Invoke-InFrontend {
        & flutter test
        if ($LASTEXITCODE -ne 0) { throw "Frontend tests failed" }
    }
}

function Invoke-TestBackend {
    Invoke-Up
    Invoke-WaitApi
    & python -m pytest -v
    if ($LASTEXITCODE -ne 0) { throw "Backend tests failed" }
}

function Invoke-TestIntegration {
    Invoke-Up
    Invoke-WaitApi
    & python -m pytest tests/integration -v
    if ($LASTEXITCODE -ne 0) { throw "Integration tests failed" }
}

function Invoke-TestFrontend {
    # Run tests with expanded reporter, capture all output (flutter test writes
    # progress to stdout, not stderr), then display failures clearly.
    Push-Location $FRONTEND_DIR
    try {
        $log = & flutter test --reporter=expanded 2>&1
        $log | Out-File "$env:TEMP\hb_flutter_test.log" -Encoding utf8
        $failures = $log | Select-String -Pattern "✗|FAILED|Test failed|description was:"
        if ($failures) {
            Write-Host "`n── Flutter Test Failures ──────────────────────────────" -ForegroundColor Red
            $failures | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
        }
        $summary = ($log | Select-String -Pattern "^\d+").Matches | Select-Object -Last 1
        Write-Host "`n── Summary ──────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host ($log | Select-Object -Last 1) -ForegroundColor Cyan
        Write-Host "Full log: $env:TEMP\hb_flutter_test.log" -ForegroundColor DarkGray
        if ($LASTEXITCODE -ne 0) { throw "Frontend tests failed" }
    }
    finally {
        Pop-Location
    }
}

function Invoke-TestFile {
    param([string]$File)
    if (-not $File) { throw "Usage: .\Make.ps1 test-file FILE=test/path/test.dart" }
    Push-Location $FRONTEND_DIR
    try {
        & flutter test --reporter=expanded $File 2>&1 |
            Select-String -Pattern "✓|✗|FAILED|Test failed|description was:|^\d+" |
            ForEach-Object { Write-Host $_.Line }
    }
    finally {
        Pop-Location
    }
}

function Invoke-Down {
    Invoke-Compose -Args @("down")
}

function Invoke-Clean {
    Invoke-Down
    Invoke-Compose -Args @("rm", "-f")
}

function Invoke-DbSeed {
    Write-Host "Reseeding database..." -ForegroundColor Cyan
    Invoke-External -Command "docker compose exec mysql mysql -u root -ppassword -e \"DROP DATABASE IF EXISTS healthdatabase; CREATE DATABASE healthdatabase;\""
    Invoke-External -Command "Get-Content -Raw database/init/01_create_database.sql | docker compose exec -T mysql mysql -u root -ppassword healthdatabase"
    Invoke-External -Command "Get-Content -Raw database/init/02_survey_seed_data.sql | docker compose exec -T mysql mysql -u root -ppassword healthdatabase"
    Write-Host "Database reseeded successfully!" -ForegroundColor Green
}

function Invoke-DbReset {
    Write-Host "Resetting database schema..." -ForegroundColor Cyan
    Invoke-External -Command "docker compose exec mysql mysql -u root -ppassword -e \"DROP DATABASE IF EXISTS healthdatabase; CREATE DATABASE healthdatabase;\""
    Invoke-External -Command "Get-Content -Raw database/init/01_create_database.sql | docker compose exec -T mysql mysql -u root -ppassword healthdatabase"
    Write-Host "Database schema reset successfully!" -ForegroundColor Green
}

function Invoke-DbMigrate {
    Write-Host "Running database migrations..." -ForegroundColor Cyan
    $files = Get-ChildItem "database/migrations/*.sql" -ErrorAction SilentlyContinue | Sort-Object Name
    foreach ($file in $files) {
        Write-Host "  Applying $($file.Name) ..." -ForegroundColor Yellow
        Get-Content -Raw $file.FullName | docker compose exec -T mysql mysql -u root -ppassword healthdatabase 2>$null
        if ($LASTEXITCODE -ne 0) { throw "Migration failed: $($file.Name)" }
    }
    Write-Host "All migrations applied!" -ForegroundColor Green
}

function Invoke-DbMigrateRemote {
    Write-Host "Running database migrations on remote server..." -ForegroundColor Cyan
    $files = Get-ChildItem "database/migrations/*.sql" -ErrorAction SilentlyContinue | Sort-Object Name
    foreach ($file in $files) {
        Write-Host "  Applying $($file.Name) ..." -ForegroundColor Yellow
        Get-Content -Raw $file.FullName | ssh upei "docker exec -i hdbtestdb mysql -u root -ppassword healthdatabase" 2>$null
        if ($LASTEXITCODE -ne 0) { throw "Remote migration failed: $($file.Name)" }
    }
    Write-Host "All remote migrations applied!" -ForegroundColor Green
}

function Invoke-DbNuke {
    Write-Host "Nuking database volume..." -ForegroundColor Cyan
    Invoke-Compose -Args @("stop", "mysql") -IgnoreError
    Invoke-Compose -Args @("rm", "-f", "mysql") -IgnoreError
    & docker volume rm -f healthbank_mysql_data 2>$null | Out-Null
    Invoke-Compose -Args @("up", "-d", "mysql")
    Write-Host "Waiting for MySQL to initialize..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Write-Host "Database nuked and restarted!" -ForegroundColor Green
}

function Invoke-ApiRestart {
    Invoke-Compose -Args @("restart", "api")
}

function Invoke-Docker {
    Write-Host "Detecting changes since last build..." -ForegroundColor Cyan

    $changed = @()
    try { $changed += (& git diff --name-only HEAD 2>$null) } catch {}
    try { $changed += (& git diff --name-only 2>$null) } catch {}
    try { $changed += (& git ls-files --others --exclude-standard 2>$null) } catch {}
    $changedText = ($changed | Where-Object { $_ } | Sort-Object -Unique) -join "`n"

    $rebuildFrontend = $false
    $rebuildApi = $false
    $rebuildNginx = $false
    $runMigrations = $false

    if ($changedText -match "(?m)^frontend/|^pubspec") { $rebuildFrontend = $true }
    if ($changedText -match "(?m)^backend/|^requirements") { $rebuildApi = $true }
    if ($changedText -match "(?m)^nginx/") { $rebuildNginx = $true }
    if ($changedText -match "(?m)^database/migrations") { $runMigrations = $true; $rebuildApi = $true }
    if ($changedText -match "(?m)^docker-compose|^Dockerfile") {
        $rebuildFrontend = $true
        $rebuildApi = $true
        $rebuildNginx = $true
    }

    if (-not $rebuildFrontend -and -not $rebuildApi -and -not $rebuildNginx) {
        Write-Host "  No source changes detected - starting existing containers." -ForegroundColor Green
        Invoke-Compose -Args @("up", "-d")
        Write-Host "Done. (Use 'make docker-new' for a full rebuild with fresh DB.)" -ForegroundColor Green
        return
    }

    $env:DOCKER_BUILDKIT = "1"

    if ($rebuildFrontend) {
        Write-Host "  Frontend changed - rebuilding frontend (pub cache preserved)..." -ForegroundColor Yellow
        Invoke-Compose -Args @("stop", "frontend", "nginx") -IgnoreError
        Invoke-Compose -Args @("rm", "-f", "frontend", "nginx") -IgnoreError
        & docker volume rm -f healthbank_frontend_build 2>$null | Out-Null
        Invoke-Compose -Args @("build", "frontend")
    }

    if ($rebuildApi) {
        Write-Host "  Backend changed - rebuilding API (pip cache preserved)..." -ForegroundColor Yellow
        Invoke-Compose -Args @("build", "api")
    }

    if ($rebuildNginx -and -not $rebuildFrontend) {
        Write-Host "  Nginx config changed - rebuilding nginx..." -ForegroundColor Yellow
        Invoke-Compose -Args @("stop", "nginx") -IgnoreError
        Invoke-Compose -Args @("rm", "-f", "nginx") -IgnoreError
        Invoke-Compose -Args @("build", "nginx")
    }

    Invoke-Compose -Args @("up", "-d")

    if ($runMigrations) {
        Write-Host "  Migration files changed - applying migrations to existing database..." -ForegroundColor Yellow
        $files = Get-ChildItem "database/migrations/*.sql" -ErrorAction SilentlyContinue | Sort-Object Name
        foreach ($file in $files) {
            Write-Host "    Applying $($file.Name) ..." -ForegroundColor Yellow
            Get-Content -Raw $file.FullName | docker compose exec -T mysql mysql -u root -ppassword healthdatabase 2>$null
        }
        Write-Host "  Migrations applied." -ForegroundColor Green
    }

    Write-Host "Rebuild complete. DB data preserved." -ForegroundColor Green
}

function Invoke-DockerFrontend {
    Invoke-Compose -Args @("stop", "frontend", "nginx") -IgnoreError
    Invoke-Compose -Args @("rm", "-f", "frontend", "nginx") -IgnoreError
    & docker volume rm -f healthbank_frontend_build 2>$null | Out-Null
    Invoke-Compose -Args @("build", "frontend")
    Invoke-Compose -Args @("up", "-d", "frontend")
    & docker wait hdb-frontend-build 2>$null | Out-Null
    Invoke-Compose -Args @("up", "-d", "nginx")
    Write-Host "Frontend rebuilt - refresh browser (Ctrl+Shift+R for hard refresh)." -ForegroundColor Green
}

function Invoke-DockerLocalBuild {
    Write-Host "Building Flutter web app locally..." -ForegroundColor Cyan
    Invoke-InFrontend {
        & flutter pub get
        if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed" }
        & dart run build_runner build --delete-conflicting-outputs
        if ($LASTEXITCODE -ne 0) { throw "build_runner failed" }
        & flutter build web --release
        if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" }
    }

    & docker rm -f hdb-nginx 2>$null | Out-Null
    Invoke-Compose -Args @("stop", "frontend", "nginx") -IgnoreError
    Invoke-Compose -Args @("rm", "-f", "frontend", "nginx") -IgnoreError
    & docker volume rm -f healthbank_frontend_build 2>$null | Out-Null
    & docker volume create healthbank_frontend_build | Out-Null

    $source = "${PWD}\$FRONTEND_DIR\build\web"
    & docker run --rm -v healthbank_frontend_build:/output -v "${source}:/src:ro" alpine sh -c "cp -r /src/* /output/"
    if ($LASTEXITCODE -ne 0) { throw "Failed to seed frontend volume" }

    Invoke-Compose -Args @("up", "-d", "mysql")
    Start-Sleep -Seconds 5
    Invoke-Compose -Args @("up", "-d", "api")
    Invoke-Compose -Args @("up", "-d", "nginx")

    Write-Host "Done. App running at http://localhost:3000" -ForegroundColor Green
}

function Invoke-DockerLocalRefresh {
    Write-Host "Rebuilding Flutter web app locally..." -ForegroundColor Cyan
    Invoke-InFrontend {
        & dart run build_runner build --delete-conflicting-outputs
        if ($LASTEXITCODE -ne 0) { throw "build_runner failed" }
        & flutter build web --release
        if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" }
    }

    Write-Host "Copying build to nginx volume..." -ForegroundColor Cyan
    $source = "${PWD}\$FRONTEND_DIR\build\web"
    & docker run --rm -v healthbank_frontend_build:/output -v "${source}:/src:ro" alpine sh -c "rm -rf /output/* && cp -r /src/* /output/"
    if ($LASTEXITCODE -ne 0) { throw "Failed to copy local web build into Docker volume" }

    Write-Host "Done. Hard refresh your browser (Ctrl+Shift+R)." -ForegroundColor Green
}

function Invoke-ServerUp {
    Invoke-ComposeServer -Args @("up", "-d", "--build")
}

function Invoke-ServerDown {
    Invoke-ComposeServer -Args @("down")
}

function Invoke-ServerRestart {
    Invoke-Compose -Args @("build", "api")
    Invoke-Compose -Args @("up", "-d", "--force-recreate", "api")
}

function Invoke-DockerNew {
    Write-Host "Rebuilding all services with fresh database..." -ForegroundColor Cyan
    Invoke-Compose -Args @("stop") -IgnoreError
    Invoke-Compose -Args @("rm", "-f") -IgnoreError
    & docker volume rm -f healthbank_mysql_data healthbank_frontend_build 2>$null | Out-Null
    $env:DOCKER_BUILDKIT = "1"
    Invoke-Compose -Args @("build")
    Invoke-Compose -Args @("up", "-d")
    Write-Host "All services rebuilt and running with fresh database." -ForegroundColor Green
    Write-Host "(Use '.\Make.ps1 docker-purge' to wipe everything including caches)" -ForegroundColor DarkGray
    Write-Host "(If this fails with a pub-cache permission error, run: docker builder prune -f)" -ForegroundColor DarkGray
}

function Invoke-DockerPurge {
    Write-Host "Purging ALL Docker resources (images, caches, volumes)..." -ForegroundColor Red
    Invoke-Compose -Args @("stop") -IgnoreError
    Invoke-Compose -Args @("rm", "-f") -IgnoreError
    & docker system prune -a --volumes -f 2>$null | Out-Null
    Write-Host "Full purge complete - next build will re-download everything." -ForegroundColor Green
}

function Invoke-DockerDev {
    Invoke-ComposeDev -Args @("up", "-d", "mysql", "api", "nginx")
    Write-Host "Backend running. Use '.\Make.ps1 flutter' to view frontend." -ForegroundColor Green
}

function Invoke-DockerDevNew {
    Invoke-ComposeDev -Args @("down") -IgnoreError
    & docker volume rm -f healthbank_mysql_data 2>$null | Out-Null
    Invoke-ComposeDev -Args @("build", "--no-cache", "api", "nginx")
    Invoke-ComposeDev -Args @("up", "-d", "mysql", "api", "nginx")
    Write-Host "Backend rebuilt with fresh DB. Use '.\Make.ps1 flutter' to view frontend." -ForegroundColor Green
}

function Invoke-DockerBack {
    Invoke-ComposeDev -Args @("up", "-d", "mysql", "api")
    Write-Host "Backend ready. Run '.\Make.ps1 flutter' in another terminal for hot reload." -ForegroundColor Green
}

function Invoke-Flutter {
    Invoke-InFrontend {
        & flutter run -d chrome "--dart-define=API_BASE_URL=$LOCAL_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-FlutterServer {
    Invoke-InFrontend {
        & flutter run -d chrome "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-FlutterBrave {
    Invoke-InFrontend {
        $env:CHROME_EXECUTABLE = $BRAVE_BIN
        & flutter run -d chrome --web-browser-flag=--new-tab "--dart-define=API_BASE_URL=$LOCAL_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-FlutterProd {
    Invoke-InFrontend {
        & flutter run -d $FLUTTER_DEVICE --release --web-browser-flag=--new-tab "--dart-define=API_BASE_URL=$LOCAL_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-Android {
    & flutter emulators --launch Pixel_9_Pro_XL 2>$null
    Write-Host "Waiting for emulator to boot..." -ForegroundColor Cyan
    & adb wait-for-device
    if ($LASTEXITCODE -ne 0) { throw "adb wait-for-device failed" }
    Start-Sleep -Seconds 5

    Invoke-InFrontend {
        & flutter run -d emulator-5554 "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-AndroidLocal {
    & flutter emulators --launch Pixel_9_Pro_XL 2>$null
    Write-Host "Waiting for emulator to boot..." -ForegroundColor Cyan
    & adb wait-for-device
    if ($LASTEXITCODE -ne 0) { throw "adb wait-for-device failed" }
    Start-Sleep -Seconds 5

    Invoke-InFrontend {
        & flutter run -d emulator-5554 "--dart-define=API_BASE_URL=$ANDROID_LOCAL_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-Ios {
    Invoke-InFrontend {
        & flutter run "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-IosLocal {
    Invoke-InFrontend {
        & flutter run "--dart-define=API_BASE_URL=$LOCAL_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-Phone {
    $apk = "$FRONTEND_DIR/build/app/outputs/flutter-apk/HealthBank-release.apk"
    if (-not (Test-Path $apk)) {
        throw "No APK found — run '.\Make.ps1 build-android' first."
    }
    $devices = & adb devices | Select-String " device$" | ForEach-Object { ($_ -split "\s+")[0] }
    if (-not $devices) { throw "No Android devices connected. Enable USB debugging and reconnect." }
    $deviceId = if (@($devices).Count -eq 1) { $devices } else {
        Write-Host "Connected devices:" -ForegroundColor Cyan
        $i = 1; foreach ($d in $devices) { Write-Host "  $i) $d"; $i++ }
        $num = Read-Host "Select device number"
        @($devices)[$num - 1]
    }
    Write-Host "Installing on $deviceId..." -ForegroundColor Cyan
    & adb -s $deviceId install -r $apk
    if ($LASTEXITCODE -ne 0) { throw "adb install failed" }
}

function Invoke-AndroidDev {
    $devices = & adb devices | Select-String " device$" | ForEach-Object { ($_ -split "\s+")[0] }
    if (-not $devices) { throw "No Android devices connected. Enable USB debugging and reconnect." }
    $deviceId = if (@($devices).Count -eq 1) { $devices } else {
        Write-Host "Connected devices:" -ForegroundColor Cyan
        $i = 1; foreach ($d in $devices) { Write-Host "  $i) $d"; $i++ }
        $num = Read-Host "Select device number"
        @($devices)[$num - 1]
    }
    Write-Host "Launching debug on $deviceId..." -ForegroundColor Cyan
    Invoke-InFrontend {
        & flutter run -d $deviceId "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-IosDev {
    Invoke-InFrontend {
        & flutter run "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter run failed" }
    }
}

function Invoke-Mobile {
    Write-Host "Building iOS release..." -ForegroundColor Cyan
    Invoke-BuildIos
    Write-Host "Building Android release..." -ForegroundColor Cyan
    Invoke-BuildAndroid
    Write-Host ""
    Write-Host "Both builds complete." -ForegroundColor Green
    Write-Host "  iOS:     frontend/build/ios/iphoneos/HealthBank.app" -ForegroundColor Gray
    Write-Host "  Android: frontend/build/app/outputs/flutter-apk/HealthBank-release.apk" -ForegroundColor Gray
}

function Invoke-BuildAndroid {
    Invoke-InFrontend {
        & flutter build apk --release "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter build apk failed" }
    }
    # Flutter always outputs app-release.apk — rename to HealthBank-release.apk
    $src = "$FRONTEND_DIR/build/app/outputs/flutter-apk/app-release.apk"
    $dst = "$FRONTEND_DIR/build/app/outputs/flutter-apk/HealthBank-release.apk"
    Copy-Item -Path $src -Destination $dst -Force
    Write-Host "Built: $dst" -ForegroundColor Green
}

function Invoke-BuildIos {
    $signingFile = "$FRONTEND_DIR/ios/Flutter/LocalSigning.xcconfig"
    $exampleFile = "$FRONTEND_DIR/ios/Flutter/LocalSigning.xcconfig.example"
    if (-not (Test-Path $signingFile)) {
        Write-Host ""
        Write-Host "=================================================================" -ForegroundColor Yellow
        Write-Host "  iOS signing not configured on this machine."
        Write-Host ""
        Write-Host "  Copy the template and fill in YOUR Apple Developer Team ID:"
        Write-Host "    Copy-Item $exampleFile $signingFile"
        Write-Host ""
        Write-Host "  Then edit that file and replace YOUR_TEAM_ID_HERE with your"
        Write-Host "  10-character Apple Developer Team ID (paid or free personal)."
        Write-Host ""
        Write-Host "  Find it via:  open $FRONTEND_DIR/ios/Runner.xcworkspace"
        Write-Host "  -> Runner target -> Signing & Capabilities -> Team dropdown"
        Write-Host "=================================================================" -ForegroundColor Yellow
        Write-Host ""
        throw "ios/Flutter/LocalSigning.xcconfig missing"
    }
    if ((Get-Content $signingFile) -match "YOUR_TEAM_ID_HERE") {
        throw "ios/Flutter/LocalSigning.xcconfig still contains YOUR_TEAM_ID_HERE — replace with your Apple Team ID."
    }
    Invoke-InFrontend {
        & flutter build ios --release "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter build ios failed" }
    }
    # Flutter always outputs Runner.app — copy to HealthBank.app
    $src = "$FRONTEND_DIR/build/ios/iphoneos/Runner.app"
    $dst = "$FRONTEND_DIR/build/ios/iphoneos/HealthBank.app"
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse -Path $src -Destination $dst
    Write-Host "Built: $dst (signed with team from ios/Flutter/LocalSigning.xcconfig)" -ForegroundColor Green
}

function Invoke-IPhone {
    $lines = & xcrun devicectl list devices 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to query devices via xcrun devicectl"
    }

    $deviceLine = $lines | Where-Object { $_ -match "iphone" } | Select-Object -First 1
    if (-not $deviceLine) {
        throw "No iPhone found. Ensure it is connected via cable or wireless pairing."
    }

    $tokens = ($deviceLine -split "\s+") | Where-Object { $_ }
    if ($tokens.Count -lt 3) {
        throw "Could not parse iPhone device id from xcrun output"
    }

    $deviceId = $tokens[2]
    & xcrun devicectl device install app --device $deviceId "frontend/build/ios/iphoneos/HealthBank.app"
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install app on iPhone device $deviceId"
    }
}

function Invoke-IPad {
echo "Found iPad device ID: $DEVICE_ID"
    $lines = & xcrun devicectl list devices 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to query devices via xcrun devicectl"
    }

    $deviceLine = $lines | Where-Object { $_ -match "ipad" } | Select-Object -First 1
    if (-not $deviceLine) {
        throw "No iPad found. Ensure it is connected via cable or wireless pairing."
    }

    $tokens = ($deviceLine -split "\s+") | Where-Object { $_ }
    if ($tokens.Count -lt 3) {
        throw "Could not parse iPad device id from xcrun output"
    }

    $deviceId = $tokens[2]
    & xcrun devicectl device install app --device $deviceId "frontend/build/ios/iphoneos/HealthBank.app"
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install app on iPad device $deviceId"
    }
}

$DEMO_DIR = "tools/demo-videos"
$SERVER_HOST = if ($env:SERVER_HOST) { $env:SERVER_HOST } else { "137.149.157.193" }
$SERVER_DIR = if ($env:SERVER_DIR) { $env:SERVER_DIR } else { "/srv/healthbank" }

function Invoke-IosAltstore {
    Invoke-InFrontend {
        & flutter build ios --release "--dart-define=API_BASE_URL=$SERVER_URL"
        if ($LASTEXITCODE -ne 0) { throw "flutter build ios failed" }
    }
    Write-Host "Packaging IPA..." -ForegroundColor Cyan
    $payload = if ($isWindowsOs) { "$env:TEMP\AltStorePayload" } else { "/tmp/AltStorePayload" }
    if (Test-Path $payload) { Remove-Item -Recurse -Force $payload }
    New-Item -ItemType Directory -Path "$payload/Payload" -Force | Out-Null
    Copy-Item -Recurse "$FRONTEND_DIR/build/ios/iphoneos/Runner.app" "$payload/Payload/HealthBank.app"
    New-Item -ItemType Directory -Path "$FRONTEND_DIR/build/ios/ipa" -Force | Out-Null
    $ipaPath = "$FRONTEND_DIR/build/ios/ipa/HealthBank.ipa"
    Push-Location $payload
    try {
        if (Get-Command zip -ErrorAction SilentlyContinue) {
            & zip -qry $ipaPath Payload
        } else {
            Compress-Archive -Path Payload -DestinationPath "$ipaPath.zip" -Force
            Move-Item "$ipaPath.zip" $ipaPath -Force
        }
    } finally { Pop-Location }
    Write-Host "IPA ready: $ipaPath" -ForegroundColor Green
}

function Invoke-Deploy {
    Write-Host "Building Flutter web locally..." -ForegroundColor Cyan
    Invoke-InFrontend { & flutter build web --release "--dart-define=API_BASE_URL=$SERVER_URL"; if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" } }
    Write-Host "Uploading to server nginx volume..." -ForegroundColor Cyan
    & rsync -az --delete "$FRONTEND_DIR/build/web/" "${SERVER_HOST}:${SERVER_DIR}/_web_deploy/"
    if ($LASTEXITCODE -ne 0) { throw "rsync failed" }
    & ssh $SERVER_HOST "docker run --rm -v $SERVER_DIR`_nginx_html:/dst -v $SERVER_DIR/_web_deploy:/src alpine sh -c 'rm -rf /dst/* && cp -a /src/. /dst/'"
    if ($LASTEXITCODE -ne 0) { throw "remote deploy failed" }
    Write-Host "Deployed." -ForegroundColor Green
}

function Invoke-DeployApi {
    Write-Host "Syncing git to server..." -ForegroundColor Cyan
    & ssh $SERVER_HOST "cd $SERVER_DIR && git fetch origin && git reset --hard origin/`$(git rev-parse --abbrev-ref HEAD)"
    if ($LASTEXITCODE -ne 0) { throw "git sync failed" }
    Write-Host "Rebuilding API on server..." -ForegroundColor Cyan
    & ssh $SERVER_HOST "cd $SERVER_DIR && make api"
    if ($LASTEXITCODE -ne 0) { throw "remote api rebuild failed" }
    Write-Host "Done." -ForegroundColor Green
}

function Invoke-DemoInstall {
    & bash "$DEMO_DIR/install.sh"
    if ($LASTEXITCODE -ne 0) { throw "demo install failed" }
}

function Invoke-DemoWebServer {
    Invoke-InFrontend { & flutter build web --release "--dart-define=API_BASE_URL=http://127.0.0.1:8000"; if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" } }
    Push-Location "$FRONTEND_DIR/build/web"
    try { & python3 -m http.server 62582 } finally { Pop-Location }
}

function Invoke-DemoWebResumable {
    & bash "$DEMO_DIR/playwright/run_all_videos.sh"
    if ($LASTEXITCODE -ne 0) { throw "run_all_videos.sh failed" }
}

function Invoke-DemoWebResumableReset {
    & bash "$DEMO_DIR/playwright/run_all_videos.sh" --reset
    if ($LASTEXITCODE -ne 0) { throw "run_all_videos.sh --reset failed" }
}

function Invoke-DemoWebExport {
    & bash "$DEMO_DIR/playwright/run_all_videos.sh" --export-only
    if ($LASTEXITCODE -ne 0) { throw "run_all_videos.sh --export-only failed" }
}

function Invoke-Playwright {
    Invoke-WaitApi
    & bash -lc "cd $DEMO_DIR/playwright && bash run_all_videos.sh"
    if ($LASTEXITCODE -ne 0) { throw "playwright orchestrator failed" }
}

function Invoke-PlaywrightTrack {
    New-Item -ItemType Directory -Path "$DEMO_DIR/output" -Force | Out-Null
    $runLog = "$DEMO_DIR/output/playwright-run.log"
    $srvLog = "$DEMO_DIR/output/demo-web-server.log"
    if (-not (Test-Path $runLog)) { New-Item -ItemType File -Path $runLog -Force | Out-Null }
    if (-not (Test-Path $srvLog)) { New-Item -ItemType File -Path $srvLog -Force | Out-Null }
    Write-Host "Tracking recorder log: $runLog"
    Write-Host "Tracking server log:   $srvLog"
    Get-Content $runLog, $srvLog -Wait -Tail 20
}

function Invoke-PatrolInstall {
    & dart pub global activate patrol_cli
    if ($LASTEXITCODE -ne 0) { throw "patrol_cli install failed" }
}

function Invoke-PatrolAndroid {
    Invoke-InFrontend {
        & flutter test integration_test/overflow_scan_test.dart -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000
        if ($LASTEXITCODE -ne 0) { throw "patrol-android run failed" }
    }
}

function Invoke-Dev {
    Write-Host "Installing Flutter dependencies for table preview..." -ForegroundColor Cyan
    Push-Location "tools/table_preview"
    try {
        & flutter pub get
        if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed in tools/table_preview" }

        Write-Host "Starting mock API + Flutter preview..." -ForegroundColor Cyan
        $uvicorn = Start-Process -FilePath "uvicorn" -ArgumentList "test_api:app", "--reload", "--port", "8001" -PassThru -WorkingDirectory (Get-Location)
        Start-Sleep -Seconds 1

        try {
            & flutter run -d chrome
            if ($LASTEXITCODE -ne 0) { throw "flutter run failed in table preview" }
        }
        finally {
            if ($uvicorn -and -not $uvicorn.HasExited) {
                Stop-Process -Id $uvicorn.Id -Force -ErrorAction SilentlyContinue
            }
        }
    }
    finally {
        Pop-Location
    }
}

function Show-List {
    Write-Host "Available targets:" -ForegroundColor Yellow
    foreach ($name in ($TargetDescriptions.Keys | Sort-Object)) {
        $desc = $TargetDescriptions[$name]
        Write-Host ("  {0,-20} {1}" -f $name, $desc)
    }
}

try {
    switch ($Target) {
        "up" { Invoke-Up }
        "front" { Invoke-Front }
        "front-new" { Invoke-FrontNew }
        "api" { Invoke-Api }
        "nginx" { Invoke-Nginx }
        "db" { Invoke-Db }
        "wait-api" { Invoke-WaitApi }
        "build" { Invoke-Build }
        "logs" { Invoke-Logs }
        "test" { Invoke-Test }
        "test-backend" { Invoke-TestBackend }
        "test-integration" { Invoke-TestIntegration }
        "test-frontend" { Invoke-TestFrontend }
        "test-file"     { Invoke-TestFile -File $FILE }
        "down" { Invoke-Down }
        "clean" { Invoke-Clean }
        "db-seed" { Invoke-DbSeed }
        "db-reset" { Invoke-DbReset }
        "db-migrate" { Invoke-DbMigrate }
        "db-migrate-remote" { Invoke-DbMigrateRemote }
        "db-nuke" { Invoke-DbNuke }
        "api-restart" { Invoke-ApiRestart }
        "docker" { Invoke-Docker }
        "docker-frontend" { Invoke-DockerFrontend }
        "docker-local-build" { Invoke-DockerLocalBuild }
        "docker-local-refresh" { Invoke-DockerLocalRefresh }
        "server-up" { Invoke-ServerUp }
        "server-down" { Invoke-ServerDown }
        "server-restart" { Invoke-ServerRestart }
        "docker-new" { Invoke-DockerNew }
        "docker-purge" { Invoke-DockerPurge }
        "docker-dev" { Invoke-DockerDev }
        "docker-dev-new" { Invoke-DockerDevNew }
        "docker-back" { Invoke-DockerBack }
        "flutter" { Invoke-Flutter }
        "flutter-server" { Invoke-FlutterServer }
        "flutter-brave" { Invoke-FlutterBrave }
        "flutter-prod" { Invoke-FlutterProd }
        "mobile" { Invoke-Mobile }
        "android" { Invoke-BuildAndroid }
        "android-dev" { Invoke-AndroidDev }
        "android-local" { Invoke-AndroidLocal }
        "phone" { Invoke-Phone }
        "ios" { Invoke-BuildIos }
        "ios-dev" { Invoke-IosDev }
        "ios-local" { Invoke-IosLocal }
        "ios-altstore" { Invoke-IosAltstore }
        "iPhone" { Invoke-IPhone }
        "iPad" { Invoke-IPad }
        "deploy" { Invoke-Deploy }
        "deploy-api" { Invoke-DeployApi }
        "demo-install" { Invoke-DemoInstall }
        "demo-web-server" { Invoke-DemoWebServer }
        "demo-web-resumable" { Invoke-DemoWebResumable }
        "demo-web-resumable-reset" { Invoke-DemoWebResumableReset }
        "demo-web-export" { Invoke-DemoWebExport }
        "playwright" { Invoke-Playwright }
        "playwright-track" { Invoke-PlaywrightTrack }
        "patrol-install" { Invoke-PatrolInstall }
        "patrol-android" { Invoke-PatrolAndroid }
        "dev" { Invoke-Dev }
        "list" { Show-List }
        "help" { Show-List }
        default {
            Write-Host "Unknown target: $Target" -ForegroundColor Red
            Show-List
            exit 1
        }
    }
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
