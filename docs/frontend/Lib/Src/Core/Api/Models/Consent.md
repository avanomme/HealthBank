# Consent API Models (`consent.dart`)

## Overview
This module defines the data models used for consent-related API operations in the frontend application. These models represent request and response payloads for:

- Checking consent status
- Submitting a signed consent form
- Viewing a user’s consent record (admin)

All models are implemented using `freezed` for immutable value types and `json_serializable` for JSON (de)serialization.

File: `frontend/lib/src/core/api/models/consent.dart`

## Architecture / Design
### Design Principles
- **Immutable models**: All classes are declared with `@freezed` and use factory constructors.
- **Explicit backend mapping**: `@JsonKey(name: ...)` is used to map Dart camelCase properties to backend snake_case keys.
- **Sealed classes**: Each model is defined as a `sealed class`, ensuring controlled extensibility and pattern-matching compatibility.
- **Generated serialization**: `fromJson` factories rely on generated code in `consent.g.dart`.

### Code Generation
The following generated files are required:

- `consent.freezed.dart`
- `consent.g.dart`

Regenerate after any model changes.

## Configuration (if applicable)
### Build Runner
Generate serialization and `freezed` code:

- Standard build:
  - `dart run build_runner build`

- Clean conflicting outputs:
  - `dart run build_runner build --delete-conflicting-outputs`

No runtime configuration is required for these models.

## API Reference
> These models define data structures only. HTTP transport, authentication, and error translation are handled elsewhere in the API layer.

---

## `ConsentStatusResponse`
Represents the response from:

- `GET /consent/status`

**Factory**
- `ConsentStatusResponse({ required bool hasSignedConsent, String? consentVersion, String? consentSignedAt, required String currentVersion, required bool needsConsent })`

**JSON**
- `ConsentStatusResponse.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `hasSignedConsent` | `bool` | Yes | `has_signed_consent` | Indicates whether the user has signed any consent |
| `consentVersion` | `String?` | No | `consent_version` | Version of the consent the user signed |
| `consentSignedAt` | `String?` | No | `consent_signed_at` | Timestamp when consent was signed |
| `currentVersion` | `String` | Yes | `current_version` | Current active consent version |
| `needsConsent` | `bool` | Yes | `needs_consent` | Whether the user must sign the latest consent |

---

## `ConsentSubmitRequest`
Represents the request body for:

- `POST /consent/submit`

**Factory**
- `ConsentSubmitRequest({ required String documentText, required String documentLanguage, required String signatureName })`

**JSON**
- `ConsentSubmitRequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `documentText` | `String` | Yes | `document_text` | Full text of the consent document presented to the user |
| `documentLanguage` | `String` | Yes | `document_language` | Language code of the document |
| `signatureName` | `String` | Yes | `signature_name` | Name entered as digital signature |

---

## `ConsentSubmitResponse`
Represents the response from:

- `POST /consent/submit`

**Factory**
- `ConsentSubmitResponse({ required bool accepted, required String version, required int consentRecordId })`

**JSON**
- `ConsentSubmitResponse.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `accepted` | `bool` | Yes | `accepted` | Indicates whether the consent was accepted and recorded |
| `version` | `String` | Yes | `version` | Consent version that was recorded |
| `consentRecordId` | `int` | Yes | `consent_record_id` | Unique identifier of the stored consent record |

---

## `UserConsentRecordResponse`
Represents the response from:

- `GET /admin/users/{id}/consent`

Used by administrators to inspect a stored consent record.

**Factory**
- `UserConsentRecordResponse({ required int consentRecordId, required int accountId, required int roleId, required String consentVersion, required String documentLanguage, required String documentText, String? signatureName, required String signedAt, String? ipAddress, String? userAgent })`

**JSON**
- `UserConsentRecordResponse.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `consentRecordId` | `int` | Yes | `consent_record_id` | Unique identifier of the consent record |
| `accountId` | `int` | Yes | `account_id` | Associated account identifier |
| `roleId` | `int` | Yes | `role_id` | Role identifier at time of signing |
| `consentVersion` | `String` | Yes | `consent_version` | Version of the consent signed |
| `documentLanguage` | `String` | Yes | `document_language` | Language of the document signed |
| `documentText` | `String` | Yes | `document_text` | Full document text that was signed |
| `signatureName` | `String?` | No | `signature_name` | Name entered at signing |
| `signedAt` | `String` | Yes | `signed_at` | Timestamp of signing |
| `ipAddress` | `String?` | No | `ip_address` | IP address recorded at signing |
| `userAgent` | `String?` | No | `user_agent` | User agent string recorded at signing |

## Error Handling
### JSON Deserialization Errors
Possible failure cases during `fromJson`:
- Missing required fields (e.g., `current_version`, `consent_record_id`)
- Type mismatches (e.g., integer fields returned as strings)
- Null values in required fields

These exceptions should be caught and translated in the API/client layer into application-specific error types.

### Date/Time Fields
Fields such as:
- `consentSignedAt`
- `signedAt`

are represented as `String`. If downstream code converts these to `DateTime`, parsing errors must be handled by the caller.

### Large Payload Consideration
`documentText` may contain large content. Consumers should:
- Avoid unnecessary in-memory duplication
- Ensure rendering is handled efficiently in UI layers

## Usage Examples (only where helpful)
### Checking consent status
```dart
final status = ConsentStatusResponse.fromJson(jsonMap);

if (status.needsConsent) {
  // Prompt user to review and sign the latest consent
}