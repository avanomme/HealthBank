#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

MODE="${1:-all}"

REQUEST_EMAIL="pw.request@hb.com"
PARTICIPANT_EMAIL="pw.participant@hb.com"
RESEARCHER_EMAIL="pw.researcher@hb.com"
HCP_EMAIL="pw.hcp@hb.com"

PARTICIPANT_TEMP_PASSWORD="TempPass!Participant1"
RESEARCHER_TEMP_PASSWORD="TempPass!Researcher1"
HCP_TEMP_PASSWORD="TempPass!Hcp1"

hash_password() {
  PASSWORD_TO_HASH="$1" python3 - <<'PY'
import base64
import hashlib
import os

password = os.environ["PASSWORD_TO_HASH"]
salt = os.urandom(32)
iterations = 210_000
dklen = 32
derived_key = hashlib.pbkdf2_hmac(
    "sha256",
    password.encode("utf-8"),
    salt,
    iterations,
    dklen=dklen,
)
print(
    "$".join(
        [
            "pbkdf2_sha256",
            str(iterations),
            str(dklen),
            base64.b64encode(salt).decode("ascii"),
            base64.b64encode(derived_key).decode("ascii"),
        ]
    )
)
PY
}

cleanup_email() {
  local email="$1"
  docker compose exec -T mysql mysql -u root -ppassword -D healthdatabase <<SQL
SET @account_id := (SELECT AccountID FROM AccountData WHERE Email = '${email}');
SET @auth_id := (SELECT AuthID FROM AccountData WHERE Email = '${email}');
DELETE FROM Sessions WHERE AccountID = @account_id;
DELETE FROM Account2FA WHERE AccountID = @account_id;
DELETE FROM ConsentRecord WHERE AccountID = @account_id;
DELETE FROM AccountDeletionRequest WHERE AccountID = @account_id;
DELETE FROM mfa_challenges WHERE AccountID = @account_id;
DELETE FROM AccountRequest WHERE Email = '${email}';
DELETE FROM AccountData WHERE Email = '${email}';
DELETE FROM Auth WHERE AuthID = @auth_id;
SQL
}

seed_participant() {
  local password_hash
  password_hash="$(hash_password "$PARTICIPANT_TEMP_PASSWORD")"

  cleanup_email "$PARTICIPANT_EMAIL"

  docker compose exec -T mysql mysql -u root -ppassword -D healthdatabase <<SQL
INSERT INTO Auth (PasswordHash, MustChangePassword)
VALUES ('${password_hash}', TRUE);
SET @auth_id := LAST_INSERT_ID();

INSERT INTO AccountData (Email, FirstName, LastName, RoleID, AuthID, IsActive, Birthdate, Gender, ConsentSignedAt, ConsentVersion)
VALUES ('${PARTICIPANT_EMAIL}', 'Playwright', 'Participant', 1, @auth_id, TRUE, NULL, NULL, NULL, NULL);
SET @account_id := LAST_INSERT_ID();

INSERT INTO AccountRequest
  (FirstName, LastName, Email, RoleID, Birthdate, Gender, Status, ReviewedBy, ReviewedAt)
VALUES
  ('Playwright', 'Participant', '${PARTICIPANT_EMAIL}', 1, NULL, NULL, 'approved', 1, UTC_TIMESTAMP());
SQL
}

seed_researcher() {
  local password_hash
  password_hash="$(hash_password "$RESEARCHER_TEMP_PASSWORD")"

  cleanup_email "$RESEARCHER_EMAIL"

  docker compose exec -T mysql mysql -u root -ppassword -D healthdatabase <<SQL
INSERT INTO Auth (PasswordHash, MustChangePassword)
VALUES ('${password_hash}', TRUE);
SET @auth_id := LAST_INSERT_ID();

INSERT INTO AccountData (Email, FirstName, LastName, RoleID, AuthID, IsActive, Birthdate, Gender, ConsentSignedAt, ConsentVersion)
VALUES ('${RESEARCHER_EMAIL}', 'Playwright', 'Researcher', 2, @auth_id, TRUE, '1988-06-12', 'Female', NULL, NULL);
SET @account_id := LAST_INSERT_ID();

INSERT INTO AccountRequest
  (FirstName, LastName, Email, RoleID, Birthdate, Gender, Status, ReviewedBy, ReviewedAt)
VALUES
  ('Playwright', 'Researcher', '${RESEARCHER_EMAIL}', 2, '1988-06-12', 'Female', 'approved', 1, UTC_TIMESTAMP());
SQL
}

seed_hcp() {
  local password_hash
  password_hash="$(hash_password "$HCP_TEMP_PASSWORD")"

  cleanup_email "$HCP_EMAIL"

  docker compose exec -T mysql mysql -u root -ppassword -D healthdatabase <<SQL
INSERT INTO Auth (PasswordHash, MustChangePassword)
VALUES ('${password_hash}', TRUE);
SET @auth_id := LAST_INSERT_ID();

INSERT INTO AccountData (Email, FirstName, LastName, RoleID, AuthID, IsActive, Birthdate, Gender, ConsentSignedAt, ConsentVersion)
VALUES ('${HCP_EMAIL}', 'Playwright', 'HCP', 3, @auth_id, TRUE, '1985-03-20', 'Male', NULL, NULL);
SET @account_id := LAST_INSERT_ID();

INSERT INTO AccountRequest
  (FirstName, LastName, Email, RoleID, Birthdate, Gender, Status, ReviewedBy, ReviewedAt)
VALUES
  ('Playwright', 'HCP', '${HCP_EMAIL}', 3, '1985-03-20', 'Male', 'approved', 1, UTC_TIMESTAMP());
SQL
}

case "$MODE" in
  request)
    cleanup_email "$REQUEST_EMAIL"
    ;;
  participant)
    seed_participant
    ;;
  researcher)
    seed_researcher
    ;;
  hcp)
    seed_hcp
    ;;
  all)
    cleanup_email "$REQUEST_EMAIL"
    seed_participant
    seed_researcher
    seed_hcp
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    exit 1
    ;;
esac

echo "Auth demo state ready for mode: $MODE"
