# WelcomeBanner

## Overview

`WelcomeBanner` is a Flutter UI widget that displays a personalized greeting for a participant. The banner renders a localized message such as:

Welcome, *FirstName*. How are you today?

It is typically used at the top of participant dashboards or landing pages.

File: `frontend/lib/src/features/participant/widgets/welcome_banner.dart`

## Architecture / Design

`WelcomeBanner` is implemented as a `StatelessWidget`. It renders a single `Text` widget containing a localized greeting string.

The greeting text is generated through the application's localization system using `context.l10n`, allowing the message to adapt to different languages.

Layout structure:

Text (localized greeting)

Styling is applied using `AppTheme.heading3` with the primary theme color.

## Configuration

Constructor:

```
const WelcomeBanner({
  Key? key,
  required String firstName,
})
```

Parameters:

* **firstName** — The participant’s first name used to personalize the greeting.

## API Reference

Class: `WelcomeBanner extends StatelessWidget`

Properties:

* `firstName : String` — User's first name inserted into the localized greeting string.

## Error Handling

This widget does not include explicit error handling.

Possible cases:

* If `firstName` is an empty string, the greeting will render without a visible name.
* The widget assumes that the localization entry `participantWelcomeGreeting` exists and is correctly configured.

## Usage Examples

Basic usage:

```
WelcomeBanner(
  firstName: "Alex",
)
```

Example in a dashboard layout:

```
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    WelcomeBanner(firstName: "Alex"),
  ],
)
```

## Related Files

* `frontend/src/core/theme/theme.dart` — Provides the `AppTheme` text styles and colors.
* `frontend/src/core/l10n/l10n.dart` — Provides the localized greeting string used by the widget.
