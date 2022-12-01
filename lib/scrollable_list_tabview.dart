library scrollable_list_tabview;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'model/scrollable_list_tab.dart';

export 'model/list_tab.dart';
export 'model/scrollable_list_tab.dart';

@visibleForTesting
const Duration kScrollDuration = const Duration(milliseconds: 150);

@visibleForTesting
const EdgeInsetsGeometry kTabMargin =
    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0);

class ScrollableListTabView extends StatefulWidget {
  /// Create a new [ScrollableListTabView]
  const ScrollableListTabView({
    Key? key,
    required this.tabs,
    this.tabHeight = kToolbarHeight,
    this.style = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    this.padding,
    this.margin,
    this.tabAnimationDuration = kScrollDuration,
    this.bodyAnimationDuration = kScrollDuration,
    this.tabAnimationCurve = Curves.decelerate,
    this.bodyAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// List of tabs to be rendered.
  final List<ScrollableListTab> tabs;

  /// Height of the tab at the top of the view.
  final double tabHeight;

  /// Duration of tab change animation.
  final TextStyle style;

  /// Duration of tab change animation.
  final Duration tabAnimationDuration;

  /// Duration of inner scroll view animation.
  final Duration bodyAnimationDuration;

  /// Animation curve used when animating tab change.
  final Curve tabAnimationCurve;

  /// Animation curve used when changing index of inner [ScrollView]s.
  final Curve bodyAnimationCurve;

  @override
  _ScrollableListTabViewState createState() => _ScrollableListTabViewState();
}

class _ScrollableListTabViewState extends State<ScrollableListTabView> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  final ItemScrollController _bodyScrollController = ItemScrollController();
  final ItemPositionsListener _bodyPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _tabScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _bodyPositionsListener.itemPositions.addListener(_onInnerViewScrolled);
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    return Column(
      children: [
        Container(
          height: widget.tabHeight,
          color: Theme.of(context).cardColor,
          child: ScrollablePositionedList.builder(
            itemCount: widget.tabs.length,
            scrollDirection: Axis.horizontal,
            itemScrollController: _tabScrollController,
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            itemBuilder: (context, index) {
              final tab = widget.tabs[index].tab;
              return ValueListenableBuilder<int>(
                valueListenable: _index,
                builder: (_, i, __) {
                  final selected = index == i;
                  final borderColor =
                      selected ? tab.activeBackgroundColor : dividerColor;
                  return Container(
                    height: 32,
                    margin: widget.margin ?? kTabMargin,
                    padding: widget.padding ?? EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: selected
                          ? tab.activeBackgroundColor
                          : tab.inactiveBackgroundColor,
                      borderRadius: tab.borderRadius,
                    ),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          selected ? Colors.white : Colors.grey,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          selected
                              ? tab.activeBackgroundColor
                              : tab.inactiveBackgroundColor,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            width: 1,
                            color: borderColor,
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0.0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: tab.borderRadius,
                          ),
                        ),
                      ),
                      child: _buildTab(index),
                      onPressed: () => _onTabPressed(index),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Flexible(
          child: ScrollablePositionedList.builder(
            itemScrollController: _bodyScrollController,
            itemPositionsListener: _bodyPositionsListener,
            itemCount: widget.tabs.length,
            itemBuilder: (_, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: widget.padding ??
                      kTabMargin.add(const EdgeInsets.all(5.0)),
                  child: _buildInnerTab(index),
                ),
                Flexible(
                  child: widget.tabs[index].body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInnerTab(int index) {
    final tab = widget.tabs[index].tab;
    return Builder(
      builder: (_) {
        return DefaultTextStyle(
          style: widget.style,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [tab.title],
          ),
        );
      },
    );
  }

  Widget _buildTab(int index) {
    final tab = widget.tabs[index].tab;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [tab.labelTab],
    );
  }

  void _onInnerViewScrolled() async {
    final positions = _bodyPositionsListener.itemPositions.value;

    /// Target [ScrollView] is not attached to any views and/or has no listeners.
    if (positions.isEmpty) return;

    /// Capture the index of the first [ItemPosition]. If the saved index is same
    /// with the current one do nothing and return.
    final firstIndex = positions.elementAt(0).index;
    if (_index.value == firstIndex) return;

    /// A new index has been detected.
    await _handleTabScroll(firstIndex);
  }

  Future<void> _handleTabScroll(int index) async {
    _index.value = index;
    await _tabScrollController.scrollTo(
      index: _index.value,
      duration: widget.tabAnimationDuration,
      curve: widget.tabAnimationCurve,
    );
  }

  /// When a new tab has been pressed both [_tabScrollController] and
  /// [_bodyScrollController] should notify their views.
  void _onTabPressed(int index) async {
    _tabScrollController.scrollTo(
      index: index,
      duration: widget.tabAnimationDuration,
      curve: widget.tabAnimationCurve,
    );
    await _bodyScrollController.scrollTo(
      index: index,
      duration: widget.bodyAnimationDuration,
      curve: widget.bodyAnimationCurve,
    );
    _index.value = index;
  }

  @override
  void dispose() {
    _bodyPositionsListener.itemPositions.removeListener(_onInnerViewScrolled);
    return super.dispose();
  }
}
