import 'package:ozoneclock/TabItem.dart';
import 'package:flutter/material.dart';

const int ANIM_DURATION = 300;

class BottomBar extends StatefulWidget {
  /// The callback that will be executed each time the tab is changed
  final Function(int position, String title, Color tabColor)
      onTabChangedListener;

  /// This color is used to show that the tab is inactive i.e not selected
  final Color inactiveIconColor;

  /// This color is used to specify the tab color
  final Color tabColor;

  /// This color is used to specify the color of text in the tab
  final Color textColor;

  /// This color is used to set up the background color of the bottom bar
  final Color barBackgroundColor;

  /// List of [TabData] to set up the bottom nav bar
  final List<TabData> tabs;

  /// [BorderRadius] to add border to the bottom bar.
  final BorderRadius barBorderRadius;

  /// This int value is used to programtically change the index of the tabs
  final int selectedTab;

  /// To add a navgation drawer of [Drawer] type
  final Drawer drawer;

  /// [TabStyle] to be defined as required, by default it will be [TabStyle.STYLE_NORMAL]
  final TabStyle tabStyle;

  /// The [Key] of the [BottomBar]
  final Key key;

  /// The inner padding of the [BottomBar]
  final EdgeInsets padding;

  /// The list of shadows of the [BottomBar]
  final List<BoxShadow> barShadow;

  BottomBar({
    @required this.tabs,
    @required this.onTabChangedListener,
    this.key,
    this.selectedTab = 0,
    this.inactiveIconColor,
    this.textColor,
    this.tabColor,
    this.barBackgroundColor,
    this.barBorderRadius,
    this.drawer,
    this.tabStyle,
    this.padding,
    this.barShadow,
  })  : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 5);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar>
    with TickerProviderStateMixin, RouteAware {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;

  Color circleColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;
  Color tabColor;

  DrawerStyle drawerStyle;
  TabStyle tabStyle;

  Icon drawerIcon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;
    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    textColor = (widget.textColor == null) ? Colors.white : widget.textColor;
    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.inactiveIconColor;

    tabColor = (widget.tabColor == null) ? activeIconColor : widget.tabColor;
  }

  @override
  void initState() {
    super.initState();
    if (widget.drawer == null) {
      drawerStyle = DrawerStyle.NO_DRAWER;
      drawerIcon = Icon(
        Icons.menu,
        color: inactiveIconColor,
      );
    } else {
      if (widget.drawer.style != null)
        drawerStyle = widget.drawer.style;
      else
        drawerStyle = DrawerStyle.NO_DRAWER;

      if (widget.drawer.icon != null)
        drawerIcon = widget.drawer.icon;
      else
        drawerIcon = Icon(
          Icons.menu,
          color: inactiveIconColor,
        );
    }
    if (widget.tabStyle == null) {
      tabStyle = TabStyle.STYLE_NORMAL;
    } else {
      tabStyle = widget.tabStyle;
    }
    _setSelected(widget.tabs[widget.selectedTab ?? 0].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);
    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _setSelected(widget.tabs[widget.selectedTab].key);
    void _handleDrawerButton() {
      Scaffold.of(context).openDrawer();
    }

    void _handleDrawerButtonEnd() {
      Scaffold.of(context).openEndDrawer();
    }

    Widget actions;
    if (drawerStyle != DrawerStyle.NO_DRAWER) {
      actions = IconButton(
        icon: drawerIcon,
        onPressed: widget.drawer.style == DrawerStyle.END_DRAWER
            ? _handleDrawerButtonEnd
            : _handleDrawerButton,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    } else {
      actions = Container();
    }
    return Stack(
      overflow: Overflow.clip,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
          decoration: BoxDecoration(
            color: barBackgroundColor,
            borderRadius: widget.barBorderRadius,
          ),
          child: setUpTabs(
            drawerStyle,
            widget.tabs,
            widget.onTabChangedListener,
            actions,
          ),
        ),
      ],
    );
  }

  rowTabs(
    List<TabData> tabs,
    Function(int position, String title, Color tabColor) onTabChangedListener,
  ) {
    return SafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: tabs
            .map((t) =>
                TabItem(
                  tabStyle: tabStyle,
                  uniqueKey: t.key,
                  selected: t.key == tabs[currentSelected].key,
                  iconData: t.iconData,
                  title: t.title,
                  callbackFunction: (uniqueKey) {
                    widget.onTabChangedListener(
                        currentSelected,
                        widget.tabs[currentSelected].title,
                        widget.tabs[currentSelected].tabColor);
                    int selected =
                        tabs.indexWhere((tabData) => tabData.key == uniqueKey);
                    onTabChangedListener(selected, t.title, inactiveIconColor);
                    _setSelected(uniqueKey);
                    _initAnimationAndStart(_circleAlignX, 1);
                  },
                ))
            .toList(),
      ),
    );
  }

  setUpTabs(
    DrawerStyle drawerStyle,
    List<TabData> tabs,
    Function(int position, String title, Color tabColor) onTabChangedListener,
    Widget actions,
  ) {
    Widget widget;
    if (drawerStyle == DrawerStyle.END_DRAWER) {
      widget = Row(
        children: <Widget>[
          Expanded(
            child: rowTabs(tabs, onTabChangedListener),
          ),
          actions,
        ],
      );
    } else if (drawerStyle == DrawerStyle.START_DRAWER) {
      widget = Row(
        children: <Widget>[
          actions,
          Expanded(
            child: rowTabs(tabs, onTabChangedListener),
          ),
        ],
      );
    } else {
      widget = rowTabs(tabs, onTabChangedListener);
    }
    return widget;
  }

  _initAnimationAndStart(double from, double to) {
    Future.delayed(Duration(milliseconds: ANIM_DURATION ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(Duration(milliseconds: (ANIM_DURATION ~/ 5 * 3)), () {
        setState(() {});
      });
    });
  }
}

class TabData {
  TabData(
      {@required this.iconData,
      @required this.title,
      this.onclick,
      this.tabColor,
      this.borderRadius,
      this.tabGradient});

  IconData iconData;
  String title;
  Function onclick;
  Color tabColor;
  Gradient tabGradient;

  final UniqueKey key = UniqueKey();
  final BorderRadius borderRadius;
}

class Drawer {
  final Icon icon;
  final DrawerStyle style;

  const Drawer({this.icon, this.style});
}

enum DrawerStyle { START_DRAWER, END_DRAWER, NO_DRAWER }

enum TabStyle { STYLE_NORMAL, STYLE_FADED_BACKGROUND }