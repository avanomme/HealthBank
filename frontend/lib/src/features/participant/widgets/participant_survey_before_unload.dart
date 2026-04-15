// Created with the Assistance of Codex
import 'package:flutter/widgets.dart';

import 'participant_survey_before_unload_stub.dart'
    if (dart.library.html) 'participant_survey_before_unload_web.dart';

/// Registers best-effort web lifecycle listeners so survey drafts can be saved
/// when the participant refreshes, closes, or backgrounds the page.
class ParticipantSurveyBeforeUnload extends StatelessWidget {
  const ParticipantSurveyBeforeUnload({
    super.key,
    required this.onBeforeUnload,
    required this.child,
  });

  final VoidCallback onBeforeUnload;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return buildParticipantSurveyBeforeUnload(
      child: child,
      onBeforeUnload: onBeforeUnload,
    );
  }
}
