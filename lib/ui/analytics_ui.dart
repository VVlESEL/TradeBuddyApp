import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/analytics_chart_ui.dart';
import 'package:trade_buddy/ui/analytics_numbers_ui.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.format_list_numbered)),
            Tab(icon: Icon(Icons.show_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          AnalyticsNumbers(),
          AnalyticsChart(),
        ],
      ),
    );
  }
}
