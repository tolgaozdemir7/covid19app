import 'package:covid19app/model/weekly_covid_stats.dart';

class CovidStatsProvider {
  WeeklyCovidStats weeklyStats;

  Future<void> load({String city = 'Turkey'}) async {
    await weeklyStats.loadData();
  }
}
