import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

void main() {
  testWidgets('Widget tests', (tester) async {
    var listTab = ScrollableListTab(
      tab: ListTab(
        label: const Text('A label'),
        icon: const Icon(Icons.ac_unit),
        showIconOnList: true,
        activeBackgroundColor: Colors.orange,
        borderColor: Colors.grey,
        inactiveBackgroundColor: Colors.transparent,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
    var widget = ScrollableListTabView(
      tabHeight: 48,
      bodyAnimationDuration: kScrollDuration,
      tabAnimationDuration: kScrollDuration,
      style: const TextStyle(
        color: Colors.grey,
      ),
      tabs: [listTab],
    );
    var testWidget = MaterialApp(
      home: Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: widget,
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    // Test our main widget.
    expect(find.byWidget(testWidget), findsOneWidget);

    /// Test whether [ScrollableListTabView] has correctly laid out.
    expect(
      find.descendant(
        of: find.byWidget(testWidget),
        matching: find.byType(
          ScrollableListTabView,
        ),
      ),
      findsOneWidget,
    );
    expect(listTab.tab, isA<ListTab>());
    expect(widget.style, isA<TextStyle>());
    expect(widget.style, const TextStyle(color: Colors.grey));
    expect(widget.tabHeight, kTextTabBarHeight);
    expect(widget.tabs.length, 1);

    /// Test animation curves
    expect(widget.tabAnimationCurve, Curves.decelerate);
    expect(widget.bodyAnimationCurve, Curves.decelerate);

    /// Test animation durations
    const duration = const Duration(milliseconds: 150);

    expect(widget.tabAnimationDuration, duration);
    expect(widget.tabAnimationDuration, duration);
  });

  test('Property test for tab models', () {
    var tab = ListTab(label: Text('A label'));
    var scrollableListTab = ScrollableListTab(
      tab: tab,
      body: ListView(
        key: Key('list_view'),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
    expect(scrollableListTab.tab, tab);
    expect(tab.borderColor, Colors.grey);
    expect(tab.showIconOnList, false);
    expect(tab.icon, null);
    expect(tab.activeBackgroundColor, Colors.blue);
    expect(((tab.label) as Text).data, 'A label');
  });
}
