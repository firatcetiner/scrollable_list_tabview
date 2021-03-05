import 'package:flutter/material.dart';
import 'list_tab.dart';

class ScrollableListTab {
  /// A skeleton class to be used in order to build the scrollable list.
  /// [ScrollableListTab.tab] will be used on both tab bar and scrollable body.
  ScrollableListTab({
    required this.tab,
    required this.body,
  }) : assert(body.shrinkWrap && body.physics is NeverScrollableScrollPhysics);

  /// A data class for tab properties
  final ListTab tab;

  /// A single widget in the scrollable tab list.
  /// Make sure that [body] is created with [ScrollView.shrinkWrap] = true
  /// and [ScrollView.physics] = [NeverScrollableScrollPhysics].
  /// This will ensure that all the children will layout correctly.
  /// For more details see [ScrollView].
  final ScrollView body;
}
