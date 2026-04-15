# syntax=docker/dockerfile:1.4
# Created with the Assistance of Claude Code
# HealthBank Flutter Web Dockerfile
# One-shot build container - builds Flutter app and copies to volume

# ------------------------------------------------------------====
# Build Flutter Web App
# ------------------------------------------------------------====
FROM ghcr.io/cirruslabs/flutter:stable

# Fix Flutter SDK git ownership check — SDK is installed by root, we build as root
RUN git config --global --add safe.directory /sdks/flutter

WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock* ./

# Get dependencies — BuildKit cache mount keeps downloaded packages across builds
# so even if pubspec.yaml changes, only new/changed packages are downloaded.
RUN --mount=type=cache,target=/root/.pub-cache \
    flutter pub get

# Copy the rest of the source code
COPY . .

# Generate code (freezed, json_serializable, retrofit, etc.)
# .dart_tool cache preserves incremental build state across docker-new runs
RUN --mount=type=cache,target=/root/.pub-cache \
    --mount=type=cache,target=/app/.dart_tool \
    flutter pub run build_runner build --delete-conflicting-outputs || true

# Build Flutter web app (release mode)
# .dart_tool cache means only changed files are recompiled on subsequent builds
RUN --mount=type=cache,target=/root/.pub-cache \
    --mount=type=cache,target=/app/.dart_tool \
    flutter build web --release

# Copy built files to output on container start
CMD ["sh", "-c", "cp -r /app/build/web/* /output/ && echo 'Frontend build complete' && ls -la /output/"]
