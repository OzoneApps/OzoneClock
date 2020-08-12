import 'package:ozoneclock/Alarms.dart';
import 'package:ozoneclock/BottomBar.dart';
import 'package:flutter/material.dart';
import 'package:ozoneclock/Stopwatch.dart';
import 'package:ozoneclock/Timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int currentPage;
  Color currentColor = Colors.deepPurple;
  Color inactiveColor = Colors.black;
  TabController tabBarController;
  List<Tabs> tabs = new List();

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    tabs.add(Tabs(Icons.alarm,"Alarm"));
    tabs.add(Tabs(Icons.language, "World"));
    tabs.add(Tabs(Icons.access_time, "Stopwatch"));
    tabs.add(Tabs(Icons.timer, "Timer"));
    tabBarController =
        new TabController(initialIndex: currentPage, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clock", style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: TabBarView(
          controller: tabBarController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Alarms(),
            Timer(),
            Stopwatch(),
          ]),
      bottomNavigationBar: BottomBar(
        inactiveIconColor: inactiveColor,
        tabStyle: TabStyle.STYLE_FADED_BACKGROUND,
        selectedTab: currentPage,
        tabs: tabs
            .map((value) => TabData(
                iconData: value.icon,
                title: value.title))
            .toList(),
        onTabChangedListener: (position, title, color) {
          setState(() {
            tabBarController.animateTo(position);
            currentPage = position;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}

class Tabs {
  final IconData icon;
  final String title;
  Tabs(this.icon, this.title);
}