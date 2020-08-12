import 'package:ozoneclock/BottomBar.dart';
import 'package:flutter/material.dart';
import 'package:ozoneclock/consts.dart';

const double ICON_OFF = -3;
const double ICON_ON = 0;
const double TEXT_OFF = 3;
const double TEXT_ON = 1;
const double ALPHA_OFF = 0;
const double ALPHA_ON = 1;

class TabItem extends StatefulWidget {
  TabItem(
      {@required this.uniqueKey,
      @required this.selected,
      @required this.iconData,
      @required this.title,
      @required this.callbackFunction,
      this.tabStyle});

  final UniqueKey uniqueKey;
  final String title;
  final IconData iconData;
  final bool selected;
  final Function(UniqueKey uniqueKey) callbackFunction;
  final double iconYAlign = ICON_ON;
  final double textYAlign = TEXT_OFF;
  final double iconAlpha = ALPHA_ON;
  final GlobalKey stickyKey = GlobalKey();
  final TabStyle tabStyle;

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  @override
  Widget build(BuildContext context) {
    double elev = widget.selected ? 3 : 0;
    Color iconColor = widget.selected ? base : Colors.grey;
    return InkWell(
      child: Card(
        elevation: elev,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: AnimatedContainer(
          padding: EdgeInsets.fromLTRB(15.0, 7.0, 15.0, 7.0),
          duration: Duration(milliseconds: ANIM_DURATION),
          child: AnimatedContainer(
            duration: Duration(milliseconds: ANIM_DURATION),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.iconData,
                  color: iconColor,
                ),
                SizedBox(width: 8.0),
                AnimatedContainer(
                  duration: Duration(milliseconds: ANIM_DURATION),
                  padding: widget.selected
                      ? EdgeInsets.only(left: 3.0, right: 3.0)
                      : EdgeInsets.all(0.0),
                  child: Text(
                    widget.selected ? widget.title : "",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        widget.callbackFunction(widget.uniqueKey);
      },
    );
  }
}
