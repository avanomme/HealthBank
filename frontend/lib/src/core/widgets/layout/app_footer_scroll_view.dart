import 'package:flutter/material.dart';

/// Scroll view that keeps a footer pinned to the viewport bottom when content
/// is shorter than the available height, and lets it scroll naturally when the
/// list grows taller than the viewport.
class AppFooterScrollView extends StatelessWidget {
  const AppFooterScrollView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.footer,
    this.padding = EdgeInsets.zero,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget footer;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: itemCount,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              const Spacer(),
              footer,
            ],
          ),
        ),
      ],
    );
  }
}
