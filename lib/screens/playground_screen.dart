import 'package:covid19app/model/weekly_covid_stats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaygroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<WeeklyCovidStats>(
          create: (_) => WeeklyCovidStats().loadData(),
        ),
      ],
      child: Scaffold(
        body: BodyContainer(),
      ),
    );
  }
}

class BodyContainer extends StatelessWidget {
  const BodyContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);
    // print(stats.statsOfToday);
    return stats == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(stats.today),
                Text(stats.statsOfToday.activeCount.toString()),
                Text(stats.statsOfToday.affectedCount.toString()),
                Text(stats.statsOfToday.country.toString()),
                Text(stats.statsOfToday.date.toString()),
                Text(stats.statsOfToday.deathCount.toString()),
                Text('---'),
                Text(stats.weeklyStats[3].deathCount.toString()),
                Text(stats.weeklyStats[3].date.toString()),
                Text(stats.statsOfYesterday.date.toString()),
              ],
            ),
          ));
  }
}
