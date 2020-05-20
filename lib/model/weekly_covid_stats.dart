import 'dart:convert';

import 'package:covid19app/model/covid_stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class WeeklyCovidStats with ChangeNotifier {
  static const String apiKey =
      '8829986cc6msheef6c473f38124bp1e639bjsn6b83e414c286';

  List<CovidStats> _covidStats = [];
  bool isLoading = false;

  static final WeeklyCovidStats instance = WeeklyCovidStats();

  String _selectedCountry = 'Turkey';
  int _selectedTab = 0;

  set selectedTab(int val) {
    if (val < 0 || val > 1 || val == _selectedTab) return;
    _selectedTab = val;
    notifyListeners();
  }

  int get selectedTab {
    return _selectedTab;
  }

  String get selectedCountry {
    return _selectedCountry;
  }

  set selectedCountry(String country) {
    if (country == _selectedCountry) return;
    _selectedCountry = country;
    notifyListeners();
  }

  Future<void> update() async {
    //_covidStats = null;
    await loadData();
    notifyListeners();
  }

  set weeklyStats(List<CovidStats> newStats) {
    if (newStats == null) {
      _covidStats = null;
      return;
    }
    _covidStats = [...newStats];
  }

  List<CovidStats> get weeklyStats {
    return _covidStats;
  }

  CovidStats get statsOfToday {
    if (_covidStats.isEmpty) {
      return null;
    }
    notifyListeners();
    return weeklyStats[0];
  }

  CovidStats get statsOfYesterday {
    if (_covidStats.isEmpty) return null;
    notifyListeners();
    return weeklyStats[1];
  }

  String get today {
    return DateFormat('y-MM-d').format(DateTime.now());
  }

  String get yesterday {
    return DateFormat('y-MM-d')
        .format(DateTime.now().subtract(Duration(days: 1)));
  }

  int getNewDeaths(int index, {List<CovidStats> list}) {
    print(list);
    final List<CovidStats> tmp = list ?? weeklyStats;
    if (tmp.length < index + 1) return 0;
    return tmp[index + 1].deathCount - tmp[index].deathCount;
  }

  int getNewActiveCases(int index, {List<CovidStats> list}) {
    final List<CovidStats> tmp = list ?? weeklyStats;
    if (tmp.length < index + 1) return 0;
    return tmp[index + 1].activeCount - tmp[index].activeCount;
  }

  CovidStats getStats(_selectedIndex) {
    return CovidStats(
      activeCount: weeklyStats[_selectedIndex].activeCount,
      affectedCount: weeklyStats[_selectedIndex].affectedCount,
      seriousCount: weeklyStats[_selectedIndex].seriousCount,
      country: weeklyStats[_selectedIndex].country,
      date: weeklyStats[_selectedIndex].date,
      deathCount: weeklyStats[_selectedIndex].deathCount,
      recoveredCount: weeklyStats[_selectedIndex].recoveredCount,
      newActiveCases: getNewActiveCases(_selectedIndex),
      newDeaths: getNewDeaths(_selectedIndex),
    );
  }

  List<CovidStats> bindCovidStats(List<dynamic> list) {
    List<CovidStats> tmp = list.map((e) {
      int index = list.indexOf(e);
      return CovidStats(
        activeCount: e["activeCount"],
        affectedCount: e["affectedCount"],
        // seriousCount: e["seriousCount"],
        country: e["country"],
        date: e["date"],
        deathCount: e["deathCount"],
        recoveredCount: e["recoveredCount"],
        newActiveCases: getNewActiveCases(index),
        newDeaths: getNewDeaths(index),
      );
    }).toList();
    return tmp;
  }

  List<CovidStats> getWeeklyStats() {
    return [
      getStats(0),
      getStats(1),
      getStats(2),
      getStats(3),
      getStats(4),
      getStats(5),
      getStats(6),
    ];
  }

  Future<int> _getSeriousCases({country = 'Turkey', day = '2020-05-15'}) async {
    try {
      const String apiUrl = 'https://covid-193.p.rapidapi.com/history';
      final covidData =
          await http.get('$apiUrl?country=$country&day=$day', headers: {
        "x-rapidapi-host": 'covid-193.p.rapidapi.com',
        "x-rapidapi-key": WeeklyCovidStats.apiKey
      });
      List<dynamic> covidStats = json.decode(covidData.body)['response'];
      int result = await covidStats.last["cases"]["critical"];
      return result;
    } catch (err) {
      print(err);
    }
    return 0;
  }

  int bindSeriousCases(int today, int yesterday, int i) {
    if (i == 0)
      return today;
    else if (i == 1)
      return yesterday;
    else
      return 0;
  }

  Future<WeeklyCovidStats> loadData() async {
    isLoading = true;
    // selectedCountry = countryName;
    //
    // Api endpoint for covid numbers in last week by country
    final String url =
        'https://covid-19-fastest-update.p.rapidapi.com/total/country/$_selectedCountry';
    final response = await http.get('$url', headers: {
      "x-rapidapi-host": 'covid-19-fastest-update.p.rapidapi.com',
      "x-rapidapi-key": WeeklyCovidStats.apiKey
    });
    //
    // get weekly covid stats data and slice last weeks data
    final results = json.decode(response.body);
    List reversedResults = results.reversed.toList().sublist(0, 8);
    // map it to use
    var todays = await _getSeriousCases(
      country: selectedCountry,
      day: today,
    );
    var yesterdays = await _getSeriousCases(
      country: selectedCountry,
      day: yesterday,
    );

    var chartList = reversedResults.map((item) {
      final int i = reversedResults.indexOf(item);
      return CovidStats(
        country: item['Country'],
        affectedCount: item['Confirmed'],
        deathCount: item['Deaths'],
        recoveredCount: item['Recovered'],
        activeCount: item['Active'],
        date: DateTime.parse(item['Date']),
        newActiveCases: reversedResults.length > i + 1
            ? reversedResults[i + 1]['Active'] - item['Active']
            : 0,
        newDeaths: reversedResults.length > i + 1
            ? reversedResults[i + 1]['Deaths'] - item['Deaths']
            : 0,
        seriousCount: bindSeriousCases(todays, yesterdays, i),
      );
    }).toList();
    weeklyStats = chartList;
    isLoading = false;
    return this;
  }
}
