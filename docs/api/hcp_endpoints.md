# HCP Endpoints API Documentation

All endpoints require a valid session cookie (`session_token`).
Role IDs: 1 = participant, 2 = researcher, 3 = HCP, 4 = admin.

---

## hcp-links — `/api/v1/hcp-links`

### POST `/api/v1/hcp-links/request`

**Roles allowed:** 1, 3, 4

Initiate an HCP-patient link request. The caller and target must be opposite roles (HCP ↔ participant). Admins are treated as participants for linking purposes.

**Request body:**
```json
{
  "target_account_id": 42
}
```

**Response (201):**
```json
{
  "link_id": 7,
  "status": "pending",
  "requested_by": "hcp"
}
```

**Errors:** 400 (wrong role pairing), 404 (target not found), 409 (link already exists in pending/active state)

---

### GET `/api/v1/hcp-links/`

**Roles allowed:** 1, 3, 4

List links for the current user. HCPs see links where they are the HCP; participants/admins see links where they are the patient. Optional `?status=` query param to filter by `pending`, `active`, `rejected`, or `removed`.

**Response (200):**
```json
[
  {
    "link_id": 1,
    "hcp_id": 10,
    "patient_id": 2,
    "hcp_name": "Dr. Jane Smith",
    "patient_name": "John Doe",
    "status": "active",
    "requested_by": "hcp",
    "requested_at": "2026-01-01T09:00:00",
    "updated_at": "2026-01-02T09:00:00",
    "consent_revoked": false
  }
]
```

---

### PUT `/api/v1/hcp-links/{link_id}/respond`

**Roles allowed:** 1, 3, 4

Accept or reject a pending link request. Only the party that did NOT initiate the request can respond.

**Request body:**
```json
{
  "action": "accept"
}
```

`action` must be `"accept"` or `"reject"`.

**Response (200):**
```json
{
  "link_id": 1,
  "status": "active"
}
```

**Errors:** 400 (invalid action, link not pending), 403 (requester trying to respond to own request), 404 (link not found)

---

### POST `/api/v1/hcp-links/{link_id}/revoke-consent`

**Roles allowed:** 1 (patient only), 4 (admin)

Revoke the patient's consent for an HCP-patient link. Sets `ConsentRevoked=1`. The link record is preserved but the HCP loses data access. Only the patient who owns the link or an admin can call this endpoint.

**Response (200):**
```json
{
  "link_id": 1,
  "consent_revoked": true
}
```

**Errors:** 403 (caller is not the patient or an admin), 404 (link not found)

---

### POST `/api/v1/hcp-links/{link_id}/restore-consent`

**Roles allowed:** 1 (patient only), 4 (admin)

Restore patient consent for an HCP-patient link. Sets `ConsentRevoked=0`. Only the patient who owns the link or an admin can call this endpoint.

**Response (200):**
```json
{
  "link_id": 1,
  "consent_revoked": false
}
```

**Errors:** 403 (caller is not the patient or an admin), 404 (link not found)

---

### DELETE `/api/v1/hcp-links/{link_id}`

**Roles allowed:** 1, 3, 4

Remove an HCP-patient link (sets status to `removed`). Either party in the link, or an admin, can remove it.

**Response:** 204 No Content

**Errors:** 403 (caller not a party and not admin), 404 (link not found)

---

## hcp-patients — `/api/v1`

These endpoints allow HCPs to access data for their linked patients. All data access is gated on an active `HcpPatientLink` where `ConsentRevoked = 0`. Admins bypass the link check.

---

### GET `/api/v1/hcp/patients`

**Roles allowed:** 3 (HCP), 4 (admin)

List patients linked to the calling HCP. Only returns patients where the link is `active` and `ConsentRevoked = 0`.

**Query params (admin only):** `?hcp_id=<int>` — filter patients by a specific HCP's account ID. If omitted, admin sees all active consented links.

**Response (200):**
```json
[
  {
    "link_id": 1,
    "patient_id": 2,
    "patient_name": "Jane Doe",
    "linked_since": "2026-01-01T09:00:00"
  }
]
```

---

### GET `/api/v1/hcp/patients/{patient_id}/surveys`

**Roles allowed:** 3 (HCP), 4 (admin)

Return completed surveys for a linked patient. For HCP callers, verifies an active consented link exists first. Returns survey assignments with status `completed`.

**Response (200):**
```json
[
  {
    "assignment_id": 12,
    "survey_id": 3,
    "survey_title": "Health Assessment Q1 2026",
    "completed_at": "2026-01-20T14:30:00"
  }
]
```

**Errors:** 403 (no active consented link — HCP only)

---

### GET `/api/v1/hcp/patients/{patient_id}/responses/{survey_id}`

**Roles allowed:** 3 (HCP), 4 (admin)

Return a patient's responses for a specific survey. For HCP callers, verifies an active consented link exists first. Returns 404 if the patient has no responses for that survey.

**Response (200):**
```json
[
  {
    "question_id": 1,
    "question_content": "How many hours of sleep do you get per night?",
    "response_type": "number",
    "response_value": "7"
  },
  {
    "question_id": 2,
    "question_content": "Rate your overall health.",
    "response_type": "single_choice",
    "response_value": "Good"
  }
]
```

**Errors:** 403 (no active consented link — HCP only), 404 (no responses found)

---

## Database Schema

```sql
CREATE TABLE IF NOT EXISTS HcpPatientLink (
    LinkID INT PRIMARY KEY AUTO_INCREMENT,
    HcpID INT NOT NULL,
    PatientID INT NOT NULL,
    Status ENUM('pending', 'active', 'rejected', 'removed') DEFAULT 'pending',
    RequestedBy ENUM('hcp', 'patient') NOT NULL,
    RequestedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ConsentRevoked TINYINT(1) NOT NULL DEFAULT 0,
    UNIQUE KEY unique_hcp_patient (HcpID, PatientID),
    FOREIGN KEY (HcpID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
    FOREIGN KEY (PatientID) REFERENCES AccountData(AccountID) ON DELETE CASCADE
);
```

`ConsentRevoked = 1` means the patient has withdrawn consent. The link record is preserved for audit purposes but the HCP cannot access any patient data until consent is restored.
