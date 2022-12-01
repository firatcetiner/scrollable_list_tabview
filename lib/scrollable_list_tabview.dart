library scrollable_list_tabview;

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
    this.expandedHeight = kToolbarHeight,
    this.style = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    this.bgrTabColor,
    this.backgroundColor,
    this.highlightColor,
    this.splashColor,
    this.headerView,
    this.paddingBody,
    this.marginBody,
    this.paddingTab,
    this.marginTab,
    this.marginInnerTab,
    this.paddingInnerTab,
    this.isMaxScroll = false,
    this.floating = false,
    this.pinned = false,
    this.automaticallyImplyLeading = true,
    this.tabAnimationDuration = kScrollDuration,
    this.bodyAnimationDuration = kScrollDuration,
    this.tabAnimationCurve = Curves.decelerate,
    this.bodyAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final EdgeInsetsGeometry? paddingBody;
  final EdgeInsetsGeometry? marginBody;
  final Color? bgrTabColor;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? splashColor;
  final EdgeInsetsGeometry? paddingTab;
  final EdgeInsetsGeometry? marginTab;
  final EdgeInsetsGeometry? paddingInnerTab;
  final EdgeInsetsGeometry? marginInnerTab;

  /// List of tabs to be rendered.
  final List<ScrollableListTab> tabs;

  /// Height of the tab at the top of the view.
  final double tabHeight;

  final double expandedHeight;

  final bool isMaxScroll;
  final bool floating;
  final bool pinned;
  final bool automaticallyImplyLeading;

  final Widget? headerView;

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

  final SliverOverlapAbsorberHandle appBar = SliverOverlapAbsorberHandle();

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _bodyPositionsListener.itemPositions.addListener(_onInnerViewScrolled);
    _controller.addListener(_onScroll);
  }

  _onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const ClampingScrollPhysics(),
      controller: _controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: appBar,
            sliver: SliverAppBar(
              backgroundColor: widget.backgroundColor,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              elevation: 0,
              pinned: widget.pinned,
              floating: widget.floating,
              expandedHeight: widget.expandedHeight,
              flexibleSpace: widget.headerView ?? const SizedBox(),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(widget.tabHeight),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: widget.highlightColor ?? Colors.blueAccent,
                    splashColor: widget.splashColor ?? Colors.blueAccent,
                  ),
                  child: _buildTabBar(),
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        padding: widget.paddingBody ?? EdgeInsets.zero,
        margin: widget.marginBody ?? EdgeInsets.only(top: 48),
        height: MediaQuery.of(context).size.height,
        child: ScrollablePositionedList.builder(
          itemScrollController: _bodyScrollController,
          itemPositionsListener: _bodyPositionsListener,
          itemCount: widget.tabs.length,
          itemBuilder: (_, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInnerTab(index),
              Flexible(
                child: widget.tabs[index].body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: widget.tabHeight,
      padding: widget.paddingTab ?? EdgeInsets.zero,
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
              return GestureDetector(
                onTap: () => _onTabPressed(index),
                child: Container(
                  margin: widget.marginInnerTab ??
                      const EdgeInsets.symmetric(horizontal: 4),
                  padding: widget.paddingInnerTab ??
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? tab.activeBackgroundColor
                        : tab.inactiveBackgroundColor,
                    borderRadius: tab.borderRadius,
                  ),
                  child: _buildTab(index, selected),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInnerTab(int index) {
    final tab = widget.tabs[index].tab;
    return Builder(
      builder: (_) {
        return tab.title;
      },
    );
  }

  Widget _buildTab(int index, bool selected) {
    final tab = widget.tabs[index].tab;
    return Align(
      alignment: Alignment.center,
      child: Text(
        tab.labelTab,
        style: tab.labelStyle ?? TextStyle(),
      ),
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

    if (widget.isMaxScroll) {
      _index.value = widget.tabs.length - 1;
    }
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
    _controller.removeListener(_onScroll);
    return super.dispose();
  }
}
