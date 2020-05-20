import 'package:intl/intl.dart';

class CovidStats {
  final String country;
  final int affectedCount;
  final int recoveredCount;
  final int deathCount;
  final int activeCount;
  final int seriousCount;
  final DateTime date;
  final int newActiveCases;
  final int newDeaths;

  CovidStats({
    this.country = "Turkey",
    this.affectedCount = 0,
    this.activeCount = 0,
    this.deathCount = 0,
    this.recoveredCount = 0,
    this.seriousCount = 0,
    this.date,
    this.newActiveCases,
    this.newDeaths,
  });

  static String doformat(int value) {
    return NumberFormat("###,###,###,###").format(value);
  }
}
