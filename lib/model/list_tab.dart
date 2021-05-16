import 'package:flutter/material.dart';

class ListTab {
  /// Create a new [ListTab]
  const ListTab(
      {Key key,
      this.icon,
      @required this.label,
      this.width,
      this.height,
      this.margin,
      this.padding,
      this.borderRadius = const BorderRadius.all(const Radius.circular(5.0)),
      this.activeBackgroundColor = Colors.blue,
      this.inactiveBackgroundColor = Colors.transparent,
      this.showIconOnList = false,
      this.borderColor = Colors.grey})
      : assert(label != null),
        assert(borderRadius != null),
        assert(activeBackgroundColor != null),
        assert(inactiveBackgroundColor != null),
        assert(showIconOnList != null),
        assert(borderColor != null);


  /// Height of the tab at the top of the view.
  final double height;

  /// Width of the tab at the top of the view.
  final double width;

  /// Padding of the tab at the top of the view.
  final EdgeInsetsGeometry padding;

  /// Margin of the tab at the top of the view.
  final EdgeInsetsGeometry margin;

  /// Trailing widget for a tab, typically an [Icon].
  final Widget icon;

  /// Label to be shown in the tab, must be non-null.
  final Widget label;

  /// [BorderRadius] for the a tab at the bottom tab view.
  /// This won't affect the tab in the scrollable list.
  final BorderRadiusGeometry borderRadius;

  /// Color to be used when the tab is selected.
  final Color activeBackgroundColor;

  /// Color to be used when tab is not selected
  final Color inactiveBackgroundColor;

  /// If true, the [icon] will also be shown to the user in the scrollable list.
  final bool showIconOnList;

  /// Color of the [Border] property of the inner tab [Container].
  final Color borderColor;
}
