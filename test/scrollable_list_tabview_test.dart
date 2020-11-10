import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

void main() {
  testWidgets('test', (tester) async {
    var listTab = ScrollableListTab(
        tab: ListTab(label: Text('A label')),
        body: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ));
    var widget = ScrollableListTabView(
      tabHeight: 50,
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
            matching: find.byType(ScrollableListTabView)),
        findsOneWidget);
    expect(widget.tabHeight, 50);
    expect(widget.tabs.length, 1);
  });
  
  test('Property test for tab models', () {
    var tab = ListTab(label: Text('A label'));
    var scrollableListTab = ScrollableListTab(
      tab: tab,
      body: ListView(
        key: Key('list_view'),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ));
    expect(scrollableListTab.tab, tab);
    expect(tab.borderColor, Colors.grey);
    expect(tab.showIconOnList, false);
    expect(tab.icon, null);
    expect(tab.activeBackgroundColor, Colors.blue);
    expect(((tab.label) as Text).data, 'A label');
  });
}
