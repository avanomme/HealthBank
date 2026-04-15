#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

docker compose exec -T mysql mysql -u root -ppassword -D healthdatabase <<'SQL'
UPDATE AccountData
SET FirstName = 'Participant',
    LastName = 'User',
    Birthdate = '1990-05-15',
    Gender = 'Male'
WHERE Email = 'part@hb.com';

DELETE FROM SurveyAssignment
WHERE AccountID = 2
  AND SurveyID IN (2, 3);

INSERT INTO SurveyAssignment
  (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status, DraftData)
VALUES
  (2, 2, '2026-04-01 09:00:00', '2026-12-31 23:59:59', NULL, 'pending', NULL),
  (
    3,
    2,
    '2026-04-02 10:00:00',
    '2026-06-15 23:59:59',
    NULL,
    'pending',
    '{"7":"6","16":"45","19":"8"}'
  );

UPDATE HcpPatientLink
SET Status = 'pending',
    RequestedBy = 'hcp',
    ConsentRevoked = 0
WHERE LinkID = 10
  AND HcpID = 11
  AND PatientID = 2;

DELETE FROM FriendRequests
WHERE (RequesterID = 4 AND TargetAccountID = 2)
   OR (RequesterID = 2 AND TargetAccountID = 4)
   OR (RequesterID = 2 AND TargetEmail = 'research@hb.com')
   OR (RequesterID = 4 AND TargetEmail = 'part@hb.com');

INSERT INTO FriendRequests
  (RequesterID, TargetEmail, TargetAccountID, Status)
VALUES
  (4, 'part@hb.com', 2, 'pending');

DELETE FROM Conversations
WHERE ConvID IN (
  SELECT ConvID
  FROM (
    SELECT cp.ConvID
    FROM ConversationParticipants cp
    GROUP BY cp.ConvID
    HAVING COUNT(*) = 2
       AND SUM(cp.AccountID = 2) > 0
       AND SUM(cp.AccountID = 4) > 0
  ) conversation_ids
);
SQL

echo "Participant demo state reset for part@hb.com"
