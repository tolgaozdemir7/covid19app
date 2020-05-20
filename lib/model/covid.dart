import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CoviddddStats {
  final String country;
  final String affected;
  final String recovered;
  final String deaths;
  final String active;
  final String serious;
  final String newActiveCases;
  final String newDeaths;
  final DateTime date;

  CoviddddStats({
    this.country,
    this.deaths,
    this.affected,
    this.recovered,
    this.active,
    this.serious,
    this.newActiveCases,
    this.newDeaths,
    this.date,
  });

  String doformat(String value) {
    return NumberFormat("###,###,###,###").format(int.parse(value));
  }

  String get formattedAffected {
    return doformat(affected);
  }

  String get formattedDeaths {
    return doformat(deaths);
  }

  String get formattedRecovered {
    return doformat(recovered);
  }

  String get formattedActive {
    return doformat(active);
  }

  String get formattedSerious {
    return doformat(serious);
  }

  String get formattedNewActive {
    final value = doformat(newActiveCases);
    return '+$value';
  }

  String get formattedNewDeaths {
    final value = doformat(newDeaths);
    return '+$value';
  }
}

class Covid {
  static const String apiHost = 'covid-193.p.rapidapi.com';
  static const String apiKey =
      '8829986cc6msheef6c473f38124bp1e639bjsn6b83e414c286';

  Future<int> getSeriousCases({country = 'Turkey', day = '2020-05-15'}) async {
    try {
      const String apiUrl = 'https://covid-193.p.rapidapi.com/history';
      final covidData = await http.get('$apiUrl?country=$country&day=$day',
          headers: {
            "x-rapidapi-host": Covid.apiHost,
            "x-rapidapi-key": Covid.apiKey
          });
      List<dynamic> covidStats = json.decode(covidData.body)['response'];
      final int index = covidStats.length > 1 ? covidStats.length - 1 : 0;
      int criticalCases = covidStats[index]["cases"]["critical"];
      return criticalCases;
    } catch (err) {
      print(err);
    }

    return 0;
  }

  Future<List<dynamic>> getCountries() async {
    const String apiUrl = 'https://covid-193.p.rapidapi.com/countries';
    final response = await http.get('$apiUrl', headers: {
      "x-rapidapi-host": Covid.apiHost,
      "x-rapidapi-key": Covid.apiKey
    });
    List countries = json.decode(response.body)['response'];
    // print(countries);
    return countries;
  }

  Future<List<CoviddddStats>> getCovidTimeSeries(String countryName) async {
    // Api endpoint for covid numbers in last week by country
    //
    final String url =
        'https://covid-19-fastest-update.p.rapidapi.com/total/country/$countryName';
    final response = await http.get('$url', headers: {
      "x-rapidapi-host": 'covid-19-fastest-update.p.rapidapi.com',
      "x-rapidapi-key": Covid.apiKey
    });

    // get weekly covid stats data and slice last weeks data
    final results = json.decode(response.body);
    List reversedResults = results.reversed.toList().sublist(0, 8);

    // map it to use
    var chartList = reversedResults.map((item) {
      var country = item['Country'];
      var affected = item['Confirmed'];
      var deaths = item['Deaths'];
      var recovered = item['Recovered'];
      var active = item['Active'];
      var date = item['Date'];
      return {
        "country": country,
        "affected": affected,
        "recovered": recovered,
        "deaths": deaths,
        "active": active,
        "date": date,
        "newDeath": 0,
        "newActive": 0,
      };
    }).toList();

    chartList.asMap().forEach((index, item) {
      if (index == 7) {
        return;
      }

      chartList[index]["newActive"] =
          chartList[index]["affected"] - chartList[index + 1]["affected"];
      chartList[index]["newDeath"] =
          chartList[index]["deaths"] - chartList[index + 1]["deaths"];
    });

    chartList = chartList.sublist(0, 7);
    //
    // inject today's serious cases
    int serious = await getSeriousCases(
      day: normalizeDateString(chartList[0]["date"]),
    );
    chartList[0].putIfAbsent('serious', () => serious);
    //
    // inject yesterday's serious cases
    serious = await getSeriousCases(
      day: normalizeDateString(chartList[1]["date"]),
    );
    chartList[1].putIfAbsent('serious', () => serious);

    // print(chartList);

    List<CoviddddStats> covidStatsList = chartList
        .map((item) => CoviddddStats(
              country: item['country'],
              affected: item['affected'].toString(),
              recovered: item['recovered'].toString(),
              deaths: item['deaths'].toString(),
              active: item['active'].toString(),
              date: DateTime.parse(item['date']),
              newActiveCases: item['newActive'].toString(),
              newDeaths: item['newDeath'].toString(),
              serious: item['serious'].toString(),
            ))
        .toList();

    return covidStatsList;
  }

  String normalizeDateString(String date) {
    String today = DateFormat('y-MM-d').format(DateTime.parse(date));
    return today;
  }
}
