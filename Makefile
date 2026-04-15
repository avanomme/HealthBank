# Created with the Assistance of Claude Code
# This file was composed with help from GH Co-Pilot

COMPOSE := docker compose

.PHONY: up down build logs test test-backend test-integration test-frontend test-file wait-api clean help list docker flutter flutter-server flutter-brave flutter-prod android android-dev android-local ios ios-dev ios-local ios-altstore iPhone iPad phone mobile db-seed db-reset db-migrate db-migrate-remote docker-local-build docker-local-refresh server-up server-down server-restart docker-dev docker-dev-new docker-back dev front front-new api nginx db deploy deploy-api demo-install demo-web-server demo-web-resumable demo-web-resumable-reset demo-web-export playwright playwright-track patrol-install patrol-android docker-new docker-purge docker-frontend

FRONTEND_DIR := frontend
FLUTTER_DEVICE := chrome
SERVER_HOST  := upei
SERVER_DIR   := ~/HealthBank

# ── API target URLs ──────────────────────────────────────────────────────────
# Local Docker stack:  nginx on :3000 proxies /api/* to the API container
# Server (UPEI):       nginx on :3000 on the remote host
LOCAL_URL  := http://localhost:3000
SERVER_URL := http://137.149.157.193:3000
# Android emulator uses special loopback alias to reach the host machine
ANDROID_LOCAL_URL := http://10.0.2.2:3000

CHROME_BIN := /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
BRAVE_BIN  := /Applications/Brave Browser.app/Contents/MacOS/Brave Browser

up: ## Start containers
	$(COMPOSE) up -d

front: ## Build Flutter locally and hot-swap into nginx volume — fastest code update (~45s)
	@echo "Building Flutter web locally..."
	cd $(FRONTEND_DIR) && flutter build web --release
	@echo "Copying build to nginx volume..."
	docker run --rm \
	  -v healthbank_frontend_build:/output \
	  -v $(PWD)/$(FRONTEND_DIR)/build/web:/src:ro \
	  alpine sh -c "rm -rf /output/* && cp -r /src/* /output/"
	@echo "Done. Hard-refresh browser (Ctrl+Shift+R)."

deploy: ## Build Flutter locally then push web output to server nginx volume (~45s local build + upload)
	@echo "Building Flutter web locally..."
	cd $(FRONTEND_DIR) && flutter build web --release --dart-define=API_BASE_URL=$(SERVER_URL)
	@echo "Uploading to server nginx volume..."
	rsync -az --delete $(FRONTEND_DIR)/build/web/ $(SERVER_HOST):$(SERVER_DIR)/_web_deploy/
	ssh $(SERVER_HOST) "docker run --rm \
	  -v healthbank_frontend_build:/output \
	  -v $(SERVER_DIR)/_web_deploy:/src:ro \
	  alpine sh -c 'rm -rf /output/* && cp -r /src/* /output/'"
	@echo "Done. Hard-refresh browser (Ctrl+Shift+R)."

deploy-api: ## Push backend changes to server and rebuild API only (no frontend build)
	@echo "Syncing git to server..."
	ssh $(SERVER_HOST) "cd $(SERVER_DIR) && git fetch origin && git reset --hard origin/$$(git rev-parse --abbrev-ref HEAD)"
	@echo "Rebuilding API on server..."
	ssh $(SERVER_HOST) "cd $(SERVER_DIR) && make api"
	@echo "Done."

front-new: ## Full Docker frontend rebuild — use when packages or code-gen annotations change (~190s)
	@echo "Rebuilding frontend Docker image (Flutter SDK + pub cache preserved)..."
	-$(COMPOSE) stop frontend nginx
	-$(COMPOSE) rm -f frontend nginx
	-docker volume rm -f healthbank_frontend_build 2>/dev/null || true
	$(COMPOSE) build frontend
	$(COMPOSE) up -d --no-deps frontend
	@echo "Waiting for Flutter web build..."
	@docker wait hdb-frontend-build >/dev/null 2>&1 || true
	$(COMPOSE) up -d --no-deps nginx
	@echo "Done. Hard-refresh browser (Ctrl+Shift+R)."

api: ## Rebuild API only — keeps pip layer cache, restarts nginx so it picks up the new API
	@echo "Rebuilding API (pip install cached if requirements.txt unchanged)..."
	$(COMPOSE) build api
	$(COMPOSE) up -d --force-recreate --no-deps api
	$(COMPOSE) restart nginx
	@echo "Done."

nginx: ## Rebuild nginx config only — no Flutter/pip rebuild needed
	@echo "Rebuilding nginx..."
	$(COMPOSE) build nginx
	$(COMPOSE) up -d --force-recreate --no-deps nginx
	@echo "Done."

db: ## Recreate and reseed the database (use when DB is broken or needs a clean state)
	@echo "Stopping API to avoid stale connections..."
	-$(COMPOSE) stop api
	@echo "Dropping and recreating database..."
	$(COMPOSE) exec mysql mysql -u root -ppassword -e "DROP DATABASE IF EXISTS healthdatabase; CREATE DATABASE healthdatabase;"
	$(COMPOSE) exec mysql mysql -u root -ppassword healthdatabase < database/init/01_create_database.sql
	$(COMPOSE) exec mysql mysql -u root -ppassword healthdatabase < database/init/02_survey_seed_data.sql
	@echo "Reseeded. Restarting API..."
	$(COMPOSE) up -d --no-deps api
	@echo "Done."

wait-api: ## Wait until API responds with 200 OK
	# Poll the health endpoint until it returns 200 (timeout ~120s)
	i=0; \
	until [ "$$i" -ge 60 ]; do \
	  code=$$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000/health || true); \
	  if [ "$$code" = "200" ]; then \
	    echo "API is ready"; \
	    exit 0; \
	  fi; \
	  i=$$((i+1)); \
	  sleep 2; \
	done; \
	echo "API not ready after timeout"; \
	exit 1

build: ## Build images
	$(COMPOSE) build

logs: ## Follow API logs
	$(COMPOSE) logs -f api

# Full test suite - runs all tests (backend + frontend)
test: up wait-api ## Start containers, run all tests (backend + frontend)
	@echo "Running backend tests..."
	python -m pytest -v
	@echo "Running frontend tests..."
	cd frontend && flutter test


# Backend tests only
test-backend: up wait-api ## Run backend pytest tests only
	python -m pytest -v

# Integration tests (ensure containers are running and ready)
test-integration: up wait-api ## Run integration tests only
	python -m pytest tests/integration -v

# Frontend Flutter tests — JSON reporter parsed to show failures clearly
test-frontend: ## Run frontend Flutter tests (failures + summary only)
	@cd frontend && flutter test --reporter json | python3 ../tools/parse_flutter_test.py

# Run a single test file — make test-file FILE=test/features/auth/auth_pages_test.dart
test-file: ## Run one test file: make test-file FILE=test/features/auth/auth_pages_test.dart
	cd frontend && flutter test $(FILE)

down: ## Stop and remove containers
	$(COMPOSE) down

clean: down ## Stop containers and remove leftover resources (preserves database)
	$(COMPOSE) rm -f

db-seed: ## Reseed the database with fresh test data (drops all existing data)
	@echo "Reseeding database..."
	@docker compose exec mysql mysql -u root -ppassword -e "DROP DATABASE IF EXISTS healthdatabase; CREATE DATABASE healthdatabase;" 2>/dev/null
	@for f in $$(ls database/init/*.sql | sort); do \
	  echo "  Applying $$f ..."; \
	  docker compose exec -T mysql mysql -u root -ppassword healthdatabase < "$$f" 2>/dev/null; \
	done
	@echo "Database reseeded successfully!"

db-reset: ## Reset database schema only (no seed data)
	@echo "Resetting database schema..."
	@docker compose exec mysql mysql -u root -ppassword -e "DROP DATABASE IF EXISTS healthdatabase; CREATE DATABASE healthdatabase;" 2>/dev/null
	@docker compose exec mysql mysql -u root -ppassword healthdatabase < database/init/01_create_database.sql 2>/dev/null
	@echo "Database schema reset successfully!"

db-migrate: ## Run all pending SQL migrations against the running database
	@echo "Running database migrations..."
	@for f in $$(ls database/migrations/*.sql 2>/dev/null | sort); do \
	  echo "  Applying $$f ..."; \
	  docker compose exec -T mysql mysql -u root -ppassword healthdatabase < "$$f" 2>/dev/null; \
	done
	@echo "All migrations applied!"

db-migrate-remote: ## Run all pending SQL migrations on the remote server (via ssh upei)
	@echo "Running database migrations on remote server..."
	@for f in $$(ls database/migrations/*.sql 2>/dev/null | sort); do \
	  echo "  Applying $$f ..."; \
	  ssh upei "docker exec -i hdbtestdb mysql -u root -ppassword healthdatabase" < "$$f" 2>/dev/null; \
	done
	@echo "All remote migrations applied!"

db-nuke: ## Full database reset (removes volume, restarts fresh)
	@echo "Nuking database volume..."
	-$(COMPOSE) stop mysql
	-$(COMPOSE) rm -f mysql
	-docker volume rm -f healthbank_mysql_data
	$(COMPOSE) up -d mysql
	@echo "Waiting for MySQL to initialize..."
	@sleep 10
	@echo "Database nuked and restarted!"

api-restart: ## Restart API (for code changes with mounted volumes)
	$(COMPOSE) restart api

docker: ## Smart rebuild — only rebuilds services whose files changed since last build
	@echo "Detecting changes since last build..."
	@# Determine which services need rebuilding based on changed files.
	@# Uses git diff against HEAD (staged + unstaged) and compares mtimes of
	@# .last-build stamp files so repeated runs are instant when nothing changed.
	@REBUILD_FRONTEND=0; REBUILD_API=0; REBUILD_NGINX=0; RUN_MIGRATIONS=0; \
	\
	CHANGED=$$(git diff --name-only HEAD 2>/dev/null; git diff --name-only 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null); \
	\
	echo "$$CHANGED" | grep -qE "^frontend/|^pubspec" && REBUILD_FRONTEND=1; \
	echo "$$CHANGED" | grep -qE "^backend/|^requirements" && REBUILD_API=1; \
	echo "$$CHANGED" | grep -qE "^nginx/" && REBUILD_NGINX=1; \
	echo "$$CHANGED" | grep -qE "^database/migrations" && RUN_MIGRATIONS=1 && REBUILD_API=1; \
	echo "$$CHANGED" | grep -qE "^docker-compose|^Dockerfile" && REBUILD_FRONTEND=1 && REBUILD_API=1 && REBUILD_NGINX=1; \
	\
	if [ "$$REBUILD_FRONTEND" = "0" ] && [ "$$REBUILD_API" = "0" ] && [ "$$REBUILD_NGINX" = "0" ]; then \
	  echo "  No source changes detected — starting existing containers."; \
	  $(COMPOSE) up -d; \
	  echo "Done. (Use 'make docker-new' for a full rebuild with fresh DB.)"; \
	  exit 0; \
	fi; \
	\
	if [ "$$REBUILD_FRONTEND" = "1" ]; then \
	  echo "  Frontend changed — rebuilding frontend (pub cache preserved)..."; \
	  $(COMPOSE) stop frontend nginx; \
	  $(COMPOSE) rm -f frontend nginx; \
	  docker volume rm -f healthbank_frontend_build 2>/dev/null || true; \
	  DOCKER_BUILDKIT=1 $(COMPOSE) build frontend; \
	fi; \
	\
	if [ "$$REBUILD_API" = "1" ]; then \
	  echo "  Backend changed — rebuilding API (pip cache preserved)..."; \
	  DOCKER_BUILDKIT=1 $(COMPOSE) build api; \
	fi; \
	\
	if [ "$$REBUILD_NGINX" = "1" ] && [ "$$REBUILD_FRONTEND" = "0" ]; then \
	  echo "  Nginx config changed — rebuilding nginx..."; \
	  $(COMPOSE) stop nginx; \
	  $(COMPOSE) rm -f nginx; \
	  $(COMPOSE) build nginx; \
	fi; \
	\
	$(COMPOSE) up -d; \
	if [ "$$RUN_MIGRATIONS" = "1" ]; then \
	  echo "  Migration files changed — applying migrations to existing database..."; \
	  for f in $$(ls database/migrations/*.sql 2>/dev/null | sort); do \
	    echo "    Applying $$f ..."; \
	    docker compose exec -T mysql mysql -u root -ppassword healthdatabase < "$$f" 2>/dev/null; \
	  done; \
	  echo "  Migrations applied."; \
	fi; \
	echo "Rebuild complete. DB data preserved."

docker-frontend: ## Rebuild frontend only (keeps pub cache, clears nginx cache)
	@echo "Rebuilding frontend (keeping pub cache)..."
	-$(COMPOSE) stop frontend nginx
	-$(COMPOSE) rm -f frontend nginx
	-docker volume rm -f healthbank_frontend_build 2>/dev/null || true
	$(COMPOSE) build frontend
	$(COMPOSE) up -d frontend
	@echo "Waiting for frontend build..."
	@docker wait hdb-frontend-build >/dev/null 2>&1 || true
	$(COMPOSE) up -d nginx
	@echo "Frontend rebuilt - refresh browser (Ctrl+Shift+R for hard refresh)"

docker-local-build: ## Build Flutter locally, serve via nginx (skips slow Docker Flutter build)
	@echo "Building Flutter web app locally..."
	cd $(FRONTEND_DIR) && flutter pub get && \
	  dart run build_runner build --delete-conflicting-outputs && \
	  flutter build web --release
	@echo "Flutter build complete. Starting containers..."
	@# Clean up any orphaned nginx from previous docker-local-build runs
	-docker rm -f hdb-nginx 2>/dev/null || true
	@# Stop compose-managed frontend/nginx
	-$(COMPOSE) stop frontend nginx
	-$(COMPOSE) rm -f frontend nginx
	-docker volume rm -f healthbank_frontend_build 2>/dev/null || true
	@# Create volume and copy local build into it
	docker volume create healthbank_frontend_build
	docker run --rm -v healthbank_frontend_build:/output -v $(PWD)/$(FRONTEND_DIR)/build/web:/src:ro alpine sh -c "cp -r /src/* /output/"
	@# Start backend
	$(COMPOSE) up -d mysql
	@echo "Waiting for MySQL..."
	@sleep 5
	$(COMPOSE) up -d api
	@# Start nginx via compose (uses the existing frontend_build volume we just populated)
	$(COMPOSE) up -d nginx
	@echo ""
	@echo "Done App running at http:\/\/localhost:3000"
	@echo "  - Flutter built locally (fast)"
	@echo "  - No Docker Flutter SDK needed"
	@echo "  - To rebuild frontend only: make docker-local-refresh"

docker-local-refresh: ## Rebuild Flutter locally and update nginx (no container restart needed)
	@echo "Rebuilding Flutter web app locally..."
	cd $(FRONTEND_DIR) && dart run build_runner build --delete-conflicting-outputs && \
	  flutter build web --release
	@echo "Copying build to nginx volume..."
	docker run --rm -v healthbank_frontend_build:/output -v $(PWD)/$(FRONTEND_DIR)/build/web:/src:ro alpine sh -c "rm -rf /output/* && cp -r /src/* /output/"
	@echo "Done Hard refresh your browser (Ctrl+Shift+R)"

server-up: ## Start server with native MySQL (no Docker MySQL)
	$(COMPOSE) -f docker-compose.yml -f docker-compose.server.yml up -d --build

server-down: ## Stop server containers
	$(COMPOSE) -f docker-compose.yml -f docker-compose.server.yml down

server-restart: ## Rebuild + restart API container on server (use after Python code changes)
	$(COMPOSE) build api && $(COMPOSE) up -d --force-recreate api

docker-new: ## Full rebuild — fresh DB from init files + all services rebuilt (layer cache preserved for speed)
	@echo "Rebuilding all services with fresh database..."
	-$(COMPOSE) stop
	-$(COMPOSE) rm -f
	-docker volume rm -f healthbank_mysql_data healthbank_frontend_build 2>/dev/null || true
	DOCKER_BUILDKIT=1 $(COMPOSE) build
	$(COMPOSE) up -d
	@echo "All services rebuilt and running with fresh database"
	@echo "(Use 'make docker-purge' to wipe absolutely everything including caches)"
	@echo "(If this fails with a pub-cache permission error, run: docker builder prune -f)"

docker-purge: ## NUCLEAR — wipe everything including base images and all caches (slowest rebuild)
	@echo "Purging ALL Docker resources (images, caches, volumes)..."
	-$(COMPOSE) stop
	-$(COMPOSE) rm -f
	docker system prune -a --volumes -f 2>/dev/null || true
	@echo "Full purge complete — next build will re-download everything"

DEV_COMPOSE := $(COMPOSE) -f docker-compose.yml -f docker-compose.dev.yml

docker-dev: ## Start backend + nginx with dev CORS (for use with make flutter)
	@echo "Starting MySQL + API + Nginx with dev CORS..."
	$(DEV_COMPOSE) up -d mysql api nginx
	@echo ""
	@echo "Backend running. Use 'make flutter' to view frontend."

docker-dev-new: ## Full rebuild backend + nginx with dev CORS and fresh DB
	@echo "Full rebuild with dev CORS (no cache, fresh DB)..."
	-$(DEV_COMPOSE) down
	-docker volume rm -f healthbank_mysql_data 2>/dev/null || true
	$(DEV_COMPOSE) build --no-cache api nginx
	$(DEV_COMPOSE) up -d mysql api nginx
	@echo ""
	@echo "Backend rebuilt with fresh DB. Use 'make flutter' to view frontend."

docker-back: ## Start backend only (MySQL + API) for local Flutter development
	@echo "Starting backend services with dev CORS (MySQL + API)..."
	$(DEV_COMPOSE) up -d mysql api
	@echo "Backend ready Run 'make flutter' in another terminal for hot reload."

flutter: ## Run Flutter in Chrome → local Docker (nginx :3000)
	cd $(FRONTEND_DIR) && \
	flutter run -d chrome \
	  --dart-define=API_BASE_URL=$(LOCAL_URL)

flutter-server: ## Run Flutter in Chrome → UPEI server
	cd $(FRONTEND_DIR) && \
	flutter run -d chrome \
	  --dart-define=API_BASE_URL=$(SERVER_URL)

flutter-brave: ## Run Flutter in Brave → local Docker (nginx :3000)
	cd $(FRONTEND_DIR) && \
	CHROME_EXECUTABLE="$(BRAVE_BIN)" \
	flutter run -d chrome \
	  --web-browser-flag=--new-tab \
	  --dart-define=API_BASE_URL=$(LOCAL_URL)

flutter-prod: ## Run Flutter in Chrome release mode → local Docker
	cd $(FRONTEND_DIR) && \
	flutter run -d $(FLUTTER_DEVICE) --release \
	  --web-browser-flag=--new-tab \
	  --dart-define=API_BASE_URL=$(LOCAL_URL)

mobile: ios android ## Build both iOS and Android release → UPEI server

android: ## Build Android release APK → UPEI server (then use make phone to install)
	cd $(FRONTEND_DIR) && \
	flutter build apk --release \
	  --dart-define=API_BASE_URL=$(SERVER_URL)
	@# Flutter always outputs app-release.apk — rename to HealthBank-release.apk
	@cp $(FRONTEND_DIR)/build/app/outputs/flutter-apk/app-release.apk \
	    $(FRONTEND_DIR)/build/app/outputs/flutter-apk/HealthBank-release.apk
	@echo ""
	@echo "Build complete: build/app/outputs/flutter-apk/HealthBank-release.apk"
	@echo "Run 'make phone' to install on a connected device."

phone: ## Install release APK on a connected Android device (interactive picker)
	@APK=$(FRONTEND_DIR)/build/app/outputs/flutter-apk/HealthBank-release.apk; \
	if [ ! -f "$$APK" ]; then echo "No APK found — run 'make android' first."; exit 1; fi; \
	DEVICES=$$(adb devices | grep -v "^List" | grep -w "device" | awk '{print $$1}'); \
	COUNT=$$(printf '%s\n' $$DEVICES | grep -c .); \
	if [ "$$COUNT" = "0" ]; then echo "No Android devices connected. Enable USB debugging and reconnect."; exit 1; fi; \
	if [ "$$COUNT" = "1" ]; then \
	  DEVICE_ID=$$(printf '%s\n' $$DEVICES | head -1); \
	  echo "Installing on $$DEVICE_ID..."; \
	  adb -s "$$DEVICE_ID" install -r "$$APK"; \
	else \
	  echo "Connected devices:"; \
	  i=1; for d in $$DEVICES; do echo "  $$i) $$d"; i=$$((i+1)); done; \
	  printf "Select device number: "; read NUM < /dev/tty; \
	  DEVICE_ID=$$(printf '%s\n' $$DEVICES | sed -n "$${NUM}p"); \
	  echo "Installing on $$DEVICE_ID..."; \
	  adb -s "$$DEVICE_ID" install -r "$$APK"; \
	fi

android-dev: ## Run Flutter debug on a connected Android device (interactive picker → UPEI server)
	@DEVICES=$$(adb devices | grep -v "^List" | grep -w "device" | awk '{print $$1}'); \
	COUNT=$$(printf '%s\n' $$DEVICES | grep -c .); \
	if [ "$$COUNT" = "0" ]; then echo "No Android devices connected. Enable USB debugging and reconnect."; exit 1; fi; \
	if [ "$$COUNT" = "1" ]; then \
	  DEVICE_ID=$$(printf '%s\n' $$DEVICES | head -1); \
	  echo "Launching debug on $$DEVICE_ID..."; \
	else \
	  echo "Connected devices:"; \
	  i=1; for d in $$DEVICES; do echo "  $$i) $$d"; i=$$((i+1)); done; \
	  printf "Select device number: "; read NUM < /dev/tty; \
	  DEVICE_ID=$$(printf '%s\n' $$DEVICES | sed -n "$${NUM}p"); \
	  echo "Launching debug on $$DEVICE_ID..."; \
	fi; \
	cd $(FRONTEND_DIR) && flutter run -d "$$DEVICE_ID" \
	  --dart-define=API_BASE_URL=$(SERVER_URL)

android-local: ## Run Flutter debug on a connected Android device → local Docker (via 10.0.2.2)
	@DEVICES=$$(adb devices | grep -v "^List" | grep -w "device" | awk '{print $$1}'); \
	COUNT=$$(printf '%s\n' $$DEVICES | grep -c .); \
	if [ "$$COUNT" = "0" ]; then echo "No Android devices connected. Enable USB debugging and reconnect."; exit 1; fi; \
	if [ "$$COUNT" = "1" ]; then \
	  DEVICE_ID=$$(printf '%s\n' $$DEVICES | head -1); \
	  echo "Launching debug on $$DEVICE_ID..."; \
	else \
	  echo "Connected devices:"; \
	  i=1; for d in $$DEVICES; do echo "  $$i) $$d"; i=$$((i+1)); done; \
	  printf "Select device number: "; read NUM < /dev/tty; \
	  DEVICE_ID=$$(printf '%s\n' $$DEVICES | sed -n "$${NUM}p"); \
	  echo "Launching debug on $$DEVICE_ID..."; \
	fi; \
	cd $(FRONTEND_DIR) && flutter run -d "$$DEVICE_ID" \
	  --dart-define=API_BASE_URL=$(ANDROID_LOCAL_URL)

ios: ## Build iOS production release → UPEI server (signed with your local Xcode team; then use make iPhone or make iPad to install)
	@# Per-developer signing — each machine supplies its own Apple Team ID via
	@# ios/Flutter/LocalSigning.xcconfig (gitignored). Print hint if missing.
	@if [ ! -f "$(FRONTEND_DIR)/ios/Flutter/LocalSigning.xcconfig" ]; then \
	  echo ""; \
	  echo "═════════════════════════════════════════════════════════════════"; \
	  echo "  iOS signing not configured on this machine."; \
	  echo ""; \
	  echo "  Copy the template and fill in YOUR Apple Developer Team ID:"; \
	  echo "    cp $(FRONTEND_DIR)/ios/Flutter/LocalSigning.xcconfig.example \\"; \
	  echo "       $(FRONTEND_DIR)/ios/Flutter/LocalSigning.xcconfig"; \
	  echo ""; \
	  echo "  Then edit that file and replace YOUR_TEAM_ID_HERE with your"; \
	  echo "  10-character Apple Developer Team ID (paid or free personal)."; \
	  echo ""; \
	  echo "  Find it via:  open $(FRONTEND_DIR)/ios/Runner.xcworkspace"; \
	  echo "  -> Runner target -> Signing & Capabilities -> Team dropdown"; \
	  echo "═════════════════════════════════════════════════════════════════"; \
	  echo ""; \
	  exit 1; \
	fi
	@if grep -q YOUR_TEAM_ID_HERE "$(FRONTEND_DIR)/ios/Flutter/LocalSigning.xcconfig"; then \
	  echo "Error: ios/Flutter/LocalSigning.xcconfig still contains the placeholder."; \
	  echo "Replace YOUR_TEAM_ID_HERE with your 10-character Apple Team ID."; \
	  exit 1; \
	fi
	cd $(FRONTEND_DIR) && \
	flutter build ios --release \
	  --dart-define=API_BASE_URL=$(SERVER_URL)
	@# Flutter always outputs Runner.app — rename to HealthBank.app
	@rm -rf $(FRONTEND_DIR)/build/ios/iphoneos/HealthBank.app
	@cp -R $(FRONTEND_DIR)/build/ios/iphoneos/Runner.app \
	       $(FRONTEND_DIR)/build/ios/iphoneos/HealthBank.app
	@echo ""
	@echo "Build complete: build/ios/iphoneos/HealthBank.app"
	@echo "Signed using team from ios/Flutter/LocalSigning.xcconfig."
	@echo "Run 'make iPhone' or 'make iPad' to install."

ios-altstore: ## Build + install iOS release on connected iPhone via ideviceinstaller → SERVER_URL
	cd $(FRONTEND_DIR) && \
	flutter build ios --release \
	  --dart-define=API_BASE_URL=$(SERVER_URL)
	@echo "Packaging IPA..."
	@rm -rf /tmp/AltStorePayload && mkdir -p /tmp/AltStorePayload/Payload
	@cp -R "$(FRONTEND_DIR)/build/ios/iphoneos/Runner.app" \
	       /tmp/AltStorePayload/Payload/HealthBank.app
	@mkdir -p "$(FRONTEND_DIR)/build/ios/ipa"
	@cd /tmp/AltStorePayload && zip -qr HealthBank.ipa Payload
	@cp /tmp/AltStorePayload/HealthBank.ipa "$(FRONTEND_DIR)/build/ios/ipa/HealthBank.ipa"
	@rm -rf /tmp/AltStorePayload
	@echo "Installing to connected iPhone..."
	@DEVICE_UDID=$$(idevice_id -l 2>/dev/null | head -1); \
	if [ -z "$$DEVICE_UDID" ]; then \
	  echo "No iPhone found via USB — ensure it is connected and trusted."; \
	  exit 1; \
	fi; \
	ideviceinstaller -u "$$DEVICE_UDID" install "$(FRONTEND_DIR)/build/ios/ipa/HealthBank.ipa" && \
	echo "" && \
	echo "✓ HealthBank installed on iPhone ($$DEVICE_UDID)" && \
	echo "  API → $(SERVER_URL)" && \
	echo "" && \
	echo "Note: cert expires in 7 days. Re-run 'make ios-altstore' to refresh."

ios-dev: ## Run Flutter on iOS device/simulator in dev mode → UPEI server
	cd $(FRONTEND_DIR) && \
	flutter run \
	  --dart-define=API_BASE_URL=$(SERVER_URL)

ios-local: ## Run Flutter on iOS simulator in dev mode → local Docker (localhost:3000)
	cd $(FRONTEND_DIR) && \
	flutter run \
	  --dart-define=API_BASE_URL=$(LOCAL_URL)

iPhone: ## Install release iOS build on connected iPhone (run after build-ios)
	@echo "Locating connected iPhone..."
	@DEVICE_ID=$$(xcrun devicectl list devices 2>/dev/null | grep -i iphone | awk '{print $$3}' | head -1); \
	if [ -z "$$DEVICE_ID" ]; then \
	  echo "No iPhone found. Ensure it is connected via cable or wireless pairing."; \
	  exit 1; \
	fi; \
	DEVICE_NAME=$$(xcrun devicectl list devices 2>/dev/null | grep -i iphone | awk '{print $$1, $$2}' | head -1); \
	echo "Found: $$DEVICE_NAME ($$DEVICE_ID)"; \
	echo "Installing build/ios/iphoneos/HealthBank.app ..."; \
	xcrun devicectl device install app \
	  --device "$$DEVICE_ID" \
	  "$(FRONTEND_DIR)/build/ios/iphoneos/HealthBank.app"

iPad: ## Install release iOS build on connected iPad (run after build-ios)
	@echo "Locating connected iPad..."
	@DEVICE_ID=$$(xcrun devicectl list devices 2>/dev/null | grep -i ipad | awk '{print $$3}' | head -1); \
	if [ -z "$$DEVICE_ID" ]; then \
	  echo "No iPad found. Ensure it is connected via cable or wireless pairing."; \
	  exit 1; \
	fi; \
	DEVICE_NAME=$$(xcrun devicectl list devices 2>/dev/null | grep -i ipad | awk '{print $$1, $$2}' | head -1); \
	echo "Found: $$DEVICE_NAME ($$DEVICE_ID)"; \
	echo "Installing build/ios/iphoneos/HealthBank.app ..."; \
	xcrun devicectl device install app \
	  --device "$$DEVICE_ID" \
	  "$(FRONTEND_DIR)/build/ios/iphoneos/HealthBank.app"

dev: ## Start the table widget preview (mock API on :8001 + standalone Flutter app)
	@echo "Installing Flutter dependencies for table preview..."
	@cd tools/table_preview && flutter pub get
	@echo ""
	@echo "Starting mock API server on http://localhost:8001 ..."
	@echo "Starting Flutter preview app in Chrome..."
	@echo "(Press Ctrl+C to stop both)"
	@echo ""
	@cd tools/table_preview && \
	  uvicorn test_api:app --reload --port 8001 & UVICORN_PID=$$! ; \
	  sleep 1 && \
	  flutter run -d chrome ; \
	  kill $$UVICORN_PID 2>/dev/null || true

DEMO_DIR := tools/demo-videos

demo-install: ## Install demo video tools (Playwright) — run once
	bash $(DEMO_DIR)/install.sh

demo-web-server: ## Build Flutter web for demo recording against local API on :8000, then serve on :62582
	cd $(FRONTEND_DIR) && flutter build web --release --dart-define=API_BASE_URL=http://127.0.0.1:8000
	cd $(FRONTEND_DIR)/build/web && python3 -m http.server 62582

demo-web-resumable: ## Record all web videos one-by-one, resuming from last checkpoint (requires: make demo-web-server)
	source ~/.zshenv && bash $(DEMO_DIR)/playwright/run_all_videos.sh

demo-web-resumable-reset: ## Wipe progress checkpoint and re-record all web videos from scratch
	source ~/.zshenv && bash $(DEMO_DIR)/playwright/run_all_videos.sh --reset

demo-web-export: ## Re-export and rename already-recorded MP4s without re-running Playwright
	bash $(DEMO_DIR)/playwright/run_all_videos.sh --export-only

patrol-install: ## Install Patrol CLI for mobile integration testing
	dart pub global activate patrol_cli

patrol-android: ## Run integration tests on Android emulator (overflow scan across all pages)
	cd $(FRONTEND_DIR) && flutter test integration_test/overflow_scan_test.dart -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000

playwright: wait-api ## Build/serve demo web if needed, record all Playwright videos, export MP4s, and copy them to ./videos
	@bash -lc ' \
	  set -euo pipefail; \
	  DEMO_SERVER_LOG="$(DEMO_DIR)/output/demo-web-server.log"; \
	  PLAYWRIGHT_LOG="$(DEMO_DIR)/output/playwright-run.log"; \
	  STARTED_SERVER=0; \
	  SERVER_PID=""; \
	  echo "[playwright] waiting for API on :8000"; \
	  cleanup() { \
	    if [ "$$STARTED_SERVER" = "1" ] && [ -n "$$SERVER_PID" ]; then \
	      kill "$$SERVER_PID" 2>/dev/null || true; \
	      wait "$$SERVER_PID" 2>/dev/null || true; \
	    fi; \
	  }; \
	  trap cleanup EXIT INT TERM; \
	  if curl -sf --max-time 3 http://127.0.0.1:62582 >/dev/null; then \
	    echo "[playwright] demo web server already running on :62582"; \
	  else \
	    echo "[playwright] starting demo web server on :62582"; \
	    mkdir -p "$(DEMO_DIR)/output"; \
	    $(MAKE) demo-web-server > "$$DEMO_SERVER_LOG" 2>&1 & \
	    SERVER_PID=$$!; \
	    STARTED_SERVER=1; \
	    i=0; \
	    until [ "$$i" -ge 180 ]; do \
	      if curl -sf --max-time 3 http://127.0.0.1:62582 >/dev/null; then \
	        echo "[playwright] demo web server is ready"; \
	        break; \
	      fi; \
	      if ! kill -0 "$$SERVER_PID" 2>/dev/null; then \
	        echo "[playwright] demo web server exited before becoming ready"; \
	        tail -n 200 "$$DEMO_SERVER_LOG" || true; \
	        exit 1; \
	      fi; \
	      i=$$((i+1)); \
	      if [ $$((i % 5)) -eq 0 ]; then \
	        echo "[playwright] still waiting for demo web server..."; \
	      fi; \
	      sleep 2; \
	    done; \
	    if ! curl -sf --max-time 3 http://127.0.0.1:62582 >/dev/null; then \
	      echo "[playwright] timed out waiting for demo web server on :62582"; \
	      tail -n 200 "$$DEMO_SERVER_LOG" || true; \
	      exit 1; \
	    fi; \
	  fi; \
	  source ~/.zshenv; \
	  echo "[playwright] recording and exporting videos"; \
	  stdbuf -oL -eL bash "$(DEMO_DIR)/playwright/run_all_videos.sh" --reset | tee "$$PLAYWRIGHT_LOG"; \
	  echo "[playwright] copying final mp4 files to ./videos"; \
	  mkdir -p videos; \
	  find videos -maxdepth 1 -type f -name "*.mp4" -delete; \
	  find "$(DEMO_DIR)/output/web/videos" -maxdepth 1 -type f -name "*.mp4" -exec cp -f {} videos/ \;; \
	  COUNT=$$(find videos -maxdepth 1 -type f -name "*.mp4" | wc -l | tr -d " "); \
	  echo "[playwright] copied $$COUNT MP4 file(s) to $(PWD)/videos" \
	'

playwright-track: ## Follow live Playwright recording/export progress logs
	@mkdir -p $(DEMO_DIR)/output
	@touch $(DEMO_DIR)/output/playwright-run.log $(DEMO_DIR)/output/demo-web-server.log
	@echo "Tracking recorder log: $(DEMO_DIR)/output/playwright-run.log"
	@echo "Tracking server log:   $(DEMO_DIR)/output/demo-web-server.log"
	@echo "Press Ctrl+C to stop following logs."
	@tail -f $(DEMO_DIR)/output/playwright-run.log $(DEMO_DIR)/output/demo-web-server.log

list: ## List all available commands
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

help: list ## Alias for list
