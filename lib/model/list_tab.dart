import 'package:flutter/material.dart';

class ListTab {
  /// Create a new [ListTab]
  const ListTab({
    required this.labelTab,
    required this.title,
    this.labelStyle,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(const Radius.circular(5.0)),
    this.activeBackgroundColor = Colors.blue,
    this.inactiveBackgroundColor = Colors.amber,
    this.borderColor = Colors.grey,
  });

  /// Trailing widget for a tab, typically an [Icon].

  /// Label to be shown in the tab, must be non-null.
  final String labelTab;

  final TextStyle? labelStyle;

  final Widget title;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  /// [BorderRadius] for the a tab at the bottom tab view.
  /// This won't affect the tab in the scrollable list.
  final BorderRadiusGeometry borderRadius;

  /// Color to be used when the tab is selected.
  final Color activeBackgroundColor;

  /// Color to be used when tab is not selected
  final Color inactiveBackgroundColor;

  /// If true, the [icon] will also be shown to the user in the scrollable list.

  /// Color of the [Border] property of the inner tab [Container].
  final Color borderColor;
}
