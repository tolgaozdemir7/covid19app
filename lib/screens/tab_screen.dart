import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: <Widget>[
            Tab(child: Text('Tab 1'),),
            Tab(child: Text('Tab 2'),),
            Tab(child: Text('Tab 3'),),
          ],)
        ),
      ),
    );
  }
}
