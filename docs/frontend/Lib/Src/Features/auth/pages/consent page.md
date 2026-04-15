# ConsentPage

A post-login consent form page that displays a role-specific legal document in the user’s selected language, collects a typed signature, and submits consent before allowing access to the dashboard.

File: `frontend/lib/src/features/auth/pages/consent_page.dart`

## Overview

`ConsentPage` is a `ConsumerStatefulWidget` shown when a user has not yet signed the required consent/confidentiality agreement. It:

- Selects a role-specific title and legal document text using localization strings.
- Displays the document in a scrollable, selectable text area.
- Requires the user to:
  - Type their name as a signature
  - Check an agreement checkbox
- Submits consent via `ConsentApi.submitConsent`.
- Updates auth state to mark consent as signed.
- Navigates to the role-appropriate dashboard upon success.

The page uses `BaseScaffold` with a top `Header` and no footer.

## Architecture / Design

### Widget responsibilities

- `ConsentPage`:
  - Renders consent UI and collects inputs (signature + agreement).
  - Determines which document to show based on the authenticated user’s role.
  - Submits consent and redirects the user after success.

- `BaseScaffold` + `Header`:
  - Provides consistent top-level layout and styling for an authentication flow page.
  - Footer disabled (`showFooter: false`) to keep focus on completion.

### State and inputs

Internal state:

- `_agreed` (`bool`): agreement checkbox state.
- `_signatureText` (`String`): tracked signature text (trim-checked).
- `_isLoading` (`bool`): disables inputs and shows spinner on submit.
- `_error` (`String?`): displays a generic localized error when submission fails.

Controller:

- `_signatureController` (`TextEditingController`): bound to the signature field.

Derived state:

- `_canSubmit` (`bool`): true when:
  - `_agreed` is true
  - signature is non-empty after trimming
  - not loading

### Role-specific title and document selection

Two helpers map role → localized content:

- `_getConsentTitle(l10n, role)`
  - `researcher` → `l10n.consentResearcherTitle`
  - `hcp` → `l10n.consentHcpTitle`
  - default/participant → `l10n.consentParticipantTitle`

- `_getConsentDocument(l10n, role)`
  - `researcher` → `l10n.consentDocumentResearcher`
  - `hcp` → `l10n.consentDocumentHcp`
  - default/participant → `l10n.consentDocumentParticipant`

### Localization and date

- Uses `context.l10n` for all user-facing strings and role-specific documents.
- Displays today’s date via:
  - `DateFormat.yMMMMd().format(DateTime.now())`

### Consent submission flow

On submit (`_handleSubmit()`):

1. Verifies `_canSubmit`.
2. Reads:
   - `localeProvider` → language code (`documentLanguage`)
   - `authProvider` → user role
   - `apiClientProvider` → underlying HTTP client (`client.dio`)
3. Builds:
   - `ConsentApi(client.dio)`
4. Submits:
   - `ConsentSubmitRequest(documentText, documentLanguage, signatureName)`
5. Updates auth state:
   - `ref.read(authProvider.notifier).markConsentSigned()`
6. Navigates to role dashboard:
   - `context.go(getDashboardRouteForRole(role))`

On error:
- Sets `_error` to `context.l10n.consentErrorGeneric`
- Clears loading state

### Document display

- Document is shown in a fixed-height scroll container:
  - `BoxConstraints(maxHeight: 400)`
  - `Scrollbar(thumbVisibility: true)`
  - `SelectableText` for copying and accessibility

## Configuration

No external configuration is required, but the page expects:

- Auth state and API providers:
  - `authProvider` and its notifier
  - `apiClientProvider` (Dio client)
  - `localeProvider` (current app locale)
- Routing helpers/constants:
  - `getDashboardRouteForRole(role)`
- Localization keys:
  - Consent titles, documents, checkbox label, signature texts, error texts, submit button text
- API models:
  - `ConsentApi`, `ConsentSubmitRequest`
- Theme:
  - `AppTheme`, `Breakpoints`

## API Reference

## `ConsentPage`

### Constructor

```dart
const ConsentPage({Key? key});