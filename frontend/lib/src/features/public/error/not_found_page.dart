import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notFoundPageTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, size: 80, color: Colors.red)),
            const SizedBox(height: 16),
            Text(context.l10n.notFound404Heading, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(context.l10n.notFoundDescription),
          ],
        ),
      ),
    );
  }
}
