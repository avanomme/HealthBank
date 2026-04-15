<!-- Created with the Assistance of Claude Code -->
# Localization (l10n) Guide

> **Purpose:** Centralize all user-facing text to enable multi-language support.

## Overview

HealthBank uses Flutter's official internationalization (i18n) system with ARB files. This provides:
- Type-safe string access
- Built-in pluralization and parameter support
- Easy addition of new languages
- IDE autocompletion for all strings

## Quick Commands

```bash
# From frontend/ directory:
make l10n          # Regenerate localization files after editing ARB

# Or directly:
flutter gen-l10n   # Same result
```

## Quick Start

### Using Strings in Widgets

```dart
import 'package:frontend/src/core/l10n/l10n.dart';

// In your widget's build method:
Text(context.l10n.authLoginButton)           // "Log In"
Text(context.l10n.commonEmail)               // "Email"
Text(context.l10n.participantViewAllTasks)   // "View All Tasks"

// With parameters:
Text(context.l10n.participantWelcomeMessage('John'))  // "Welcome, John..."
Text(context.l10n.participantNewMessages(5))          // "You have 5 new messages..."
```

### The `context.l10n` Extension

We provide a convenient extension on `BuildContext` for cleaner syntax:

```dart
// Instead of:
final l10n = AppLocalizations.of(context);
Text(l10n.authLoginButton)

// Simply use:
Text(context.l10n.authLoginButton)
```

## File Structure

```
frontend/lib/src/core/l10n/
├── arb/                          # Translation files
│   └── app_en.arb                # English translations (source)
├── generated/                    # Auto-generated (DO NOT EDIT)
│   ├── app_localizations.dart    # Main localizations class
│   └── app_localizations_en.dart # English implementation
├── l10n.dart                     # Barrel file - import this
└── l10n_extension.dart           # context.l10n extension

frontend/l10n.yaml                # Configuration file
```

## Adding New Strings

### 1. Edit the ARB File

Open `frontend/lib/src/core/l10n/arb/app_en.arb` and add your string:

```json
{
  "myNewString": "My new translated text",

  "@@_MY_SECTION": "Description of this section",
  "myNewStringWithParam": "Hello, {name}!",
  "@myNewStringWithParam": {
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### 2. Regenerate the Code

```bash
cd frontend
make l10n
# Or: flutter gen-l10n
```

This automatically generates the Dart code in `lib/src/core/l10n/generated/`.

### 3. Use in Your Widget

```dart
import 'package:frontend/src/core/l10n/l10n.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(context.l10n.myNewString),
        Text(context.l10n.myNewStringWithParam('John')),
      ],
    );
  }
}
```

## ARB File Format

ARB (Application Resource Bundle) is a JSON-based format:

### Simple Strings

```json
{
  "commonSubmit": "Submit",
  "commonCancel": "Cancel"
}
```

### Strings with Parameters

```json
{
  "participantWelcomeMessage": "Welcome, {name}. How are you today?",
  "@participantWelcomeMessage": {
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### Pluralized Strings

```json
{
  "participantNewMessages": "{count, plural, =1{You have 1 new message.} other{You have {count} new messages.}}",
  "@participantNewMessages": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### Section Comments

Use `@@_` prefix for section comments (ignored by generator):

```json
{
  "@@_AUTH_LOGIN": "Login page strings",
  "authLoginButton": "Log In",
  "authLoginTitle": "Welcome"
}
```

## String Naming Convention

Strings follow the pattern: `{category}{Description}`

| Category | Example | Purpose |
|----------|---------|---------|
| `common` | `commonSubmit` | Shared across app |
| `auth` | `authLoginButton` | Authentication |
| `nav` | `navDashboard` | Navigation |
| `footer` | `footerPrivacy` | Footer links |
| `participant` | `participantMyTasks` | Participant pages |
| `researcher` | `researcherCreateSurvey` | Researcher pages |
| `hcp` | `hcpClientList` | HCP pages |
| `admin` | `adminUserManagement` | Admin pages |
| `status` | `statusPending` | Status labels |
| `error` | `errorNetwork` | Error messages |
| `validation` | `validationRequired` | Form validation |

## What Should Be Localized

### DO Localize
- Button labels (`Submit`, `Cancel`, `Save`)
- Form field labels (`Email`, `Password`)
- Error messages (`Email is required`)
- Page titles and headings
- Navigation items (`Dashboard`, `Settings`)
- Status labels (`Active`, `Pending`, `Completed`)
- Tooltips and hints
- Dialog messages

### DO NOT Localize
- **Brand name** (`HealthBank`) - Hardcode directly
- Technical identifiers
- Route paths
- API field names
- Log messages (internal only)

## Language Switching

The app uses Riverpod for locale state management:

```dart
import 'package:frontend/src/core/state/locale_provider.dart';

// Read current locale
final locale = ref.watch(localeProvider);

// Change locale
ref.read(localeProvider.notifier).setLocale(const Locale('es'));

// Reset to default (English)
ref.read(localeProvider.notifier).resetToDefault();
```

## Supported Languages

| Language | Locale Code | ARB File | Status |
|----------|-------------|----------|--------|
| English | `en` | `app_en.arb` | Complete (source) |
| French (Canadian) | `fr` | `app_fr.arb` | Complete |

The French translations follow Canadian government official bilingual standards.

## Adding a New Language

### 1. Create ARB File

Copy `app_en.arb` to `app_XX.arb` (e.g., `app_es.arb` for Spanish):

```bash
cp lib/src/core/l10n/arb/app_en.arb lib/src/core/l10n/arb/app_es.arb
```

### 2. Translate Strings

Edit `app_es.arb` and translate each string:

```json
{
  "@@locale": "es",
  "commonSubmit": "Enviar",
  "authLoginButton": "Iniciar Sesion"
}
```

### 3. Regenerate

```bash
flutter gen-l10n
```

### 4. Update Locale Provider

Add the new locale to `SupportedLocales` in `locale_provider.dart`:

```dart
class SupportedLocales {
  static const Locale english = Locale('en');
  static const Locale spanish = Locale('es');  // Add this

  static const List<Locale> all = [
    english,
    spanish,  // Add this
  ];
}
```

## Common Patterns

### Using l10n in Helper Methods

When you need l10n in a helper method without context:

```dart
// Pass l10n as a parameter
Widget _buildCard(AppLocalizations l10n) {
  return Text(l10n.authLoginButton);
}

// Call from build method
@override
Widget build(BuildContext context) {
  return _buildCard(context.l10n);
}
```

### Using l10n in Static Methods

For static factory methods that need localized strings:

```dart
class Footer {
  static FooterSection getDefaultHelpSection(AppLocalizations l10n) {
    return FooterSection(
      title: l10n.footerHelpAndServices,
      links: [
        FooterLink(label: l10n.footerHowToUse, route: '/help'),
      ],
    );
  }
}

// Usage
final section = Footer.getDefaultHelpSection(context.l10n);
```

### PopupMenuButton and Similar Widgets

Some widgets like `PopupMenuButton` have builders with their own context:

```dart
PopupMenuButton<String>(
  itemBuilder: (ctx) => [  // Use ctx, not context
    PopupMenuItem(
      child: Text(ctx.l10n.authProfile),
    ),
  ],
)
```

## Best Practices

### 1. Always Import the Barrel File

```dart
// GOOD - Import the barrel file
import 'package:frontend/src/core/l10n/l10n.dart';

// BAD - Import individual files
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/core/l10n/l10n_extension.dart';
```

### 2. Use Descriptive Names

```dart
// GOOD
"authEmailRequired": "Email is required"
"authEmailInvalid": "Please enter a valid email"

// BAD
"error1": "Email is required"
"error2": "Please enter a valid email"
```

### 3. Group Related Strings

Use section comments in ARB files:

```json
{
  "@@_AUTH_LOGIN": "Login page strings",
  "authLoginTitle": "Log In",
  "authLoginButton": "Log In",

  "@@_AUTH_LOGOUT": "Logout strings",
  "authLogoutTitle": "Logout Successful",
  "authLogoutMessage": "You have been logged out."
}
```

### 4. Run gen-l10n After Changes

Always regenerate after editing ARB files:

```bash
make l10n
# Or: flutter gen-l10n
```

## Troubleshooting

### "l10n not defined" Error

Make sure you imported the barrel file:
```dart
import 'package:frontend/src/core/l10n/l10n.dart';
```

### "Null check operator used on null value"

The localization delegates might not be configured. Check `main.dart`:
```dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: locale,
)
```

### Strings Not Updating

Run `flutter gen-l10n` to regenerate from ARB files.

## Checklist for New Features

When adding a new page or feature:

- [ ] Identify all user-facing text
- [ ] Add strings to `lib/src/core/l10n/arb/app_en.arb`
- [ ] Run `flutter gen-l10n`
- [ ] Import `package:frontend/src/core/l10n/l10n.dart`
- [ ] Use `context.l10n.stringName` instead of hardcoded text
- [ ] Keep brand name "HealthBank" hardcoded (not in ARB files)
- [ ] Test that strings display correctly

## Recent Changes

### Admin View-As & Dashboard Keys (2026-02-06)

Added 13 new keys in `@@_ADMIN_VIEW_AS` section:

| Key | English | French |
|-----|---------|--------|
| `adminDashboardTitle` | Admin Dashboard | Tableau de bord administrateur |
| `adminViewAsLabel` | View As | Voir en tant que |
| `adminBackToAdmin` | Back to Admin | Retour a l'admin |
| `adminViewingAsRole` | Viewing as {role} | Affiche en tant que {role} |
| `adminViewingAsUser` | Viewing as {name} ({email}) | Affiche en tant que {name} ({email}) |
| `adminReturnedToDashboard` | Returned to admin dashboard | Retour au tableau de bord administrateur |
| `adminEndViewAsError` | Failed to end view-as | Echec de la fin de la visualisation |
| `adminReturning` | Returning... | Retour en cours... |
| `adminWelcomeMessage` | Welcome to the admin dashboard... | Bienvenue sur le tableau de bord... |
| `roleParticipant` | Participant | Participant |
| `roleResearcher` | Researcher | Chercheur |
| `roleHcp` | Healthcare Professional | Professionnel de la sante |

### Research Data Keys (2026-02-06)

Added 16 French translations for research data page keys that were only in English.

## Related Documentation

- [Theme Guide](./theme.md) - Colors and typography
- [Flutter i18n Docs](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
