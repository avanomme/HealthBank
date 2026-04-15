// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

// Created with the Assistance of Codex
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/widgets.dart';

Widget buildParticipantSurveyBeforeUnload({
  required Widget child,
  required VoidCallback onBeforeUnload,
}) {
  return _ParticipantSurveyBeforeUnloadWeb(
    onBeforeUnload: onBeforeUnload,
    child: child,
  );
}

class _ParticipantSurveyBeforeUnloadWeb extends StatefulWidget {
  const _ParticipantSurveyBeforeUnloadWeb({
    required this.onBeforeUnload,
    required this.child,
  });

  final VoidCallback onBeforeUnload;
  final Widget child;

  @override
  State<_ParticipantSurveyBeforeUnloadWeb> createState() =>
      _ParticipantSurveyBeforeUnloadWebState();
}

class _ParticipantSurveyBeforeUnloadWebState
    extends State<_ParticipantSurveyBeforeUnloadWeb> {
  StreamSubscription<html.Event>? _beforeUnloadSubscription;
  StreamSubscription<html.Event>? _visibilitySubscription;

  @override
  void initState() {
    super.initState();
    _beforeUnloadSubscription = html.window.onBeforeUnload.listen((_) {
      widget.onBeforeUnload();
    });
    _visibilitySubscription = html.document.onVisibilityChange.listen((_) {
      if (html.document.visibilityState == 'hidden') {
        widget.onBeforeUnload();
      }
    });
  }

  @override
  void dispose() {
    _beforeUnloadSubscription?.cancel();
    _visibilitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
