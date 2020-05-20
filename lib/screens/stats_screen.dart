// DONE: Loading için ilgili görselleri kullan
// DONE: Tab sayısını 2'ye düşür
// DONE: Grafiği düzenle ve kullanıma hazırla
// DONE: Ekran yüksekliğini dinamik olarak ayarla
// DONE: Farklı ülkelerin datasını kullanmaya başla

import 'package:covid19app/model/weekly_covid_stats.dart';
import 'package:covid19app/widgets/app_bar.dart';
import 'package:covid19app/widgets/chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/statistics.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<bool> _selected = [true, false];
  int _selectedIndex = 0;
  bool isLoading = false;
  String selectedCountry = "Italy";
  // CovidStats covidStats;

  void updateSelectedTabItem(int selectedItemIndex) {
    var newSelectedList = List<bool>.generate(
        2, (index) => index == selectedItemIndex ? true : false);

    setState(() {
      _selected = newSelectedList;
      _selectedIndex = selectedItemIndex;
    });

    final stats = Provider.of<WeeklyCovidStats>(context, listen: false);
    stats.selectedTab = selectedItemIndex;
    // stats.isLoading = true;
    // stats.update().then((value) => setState(() {
    //       isLoading = false;
    //     }));
  }

  void updateStatsForAnotherCountry(country) {
    final stats = Provider.of<WeeklyCovidStats>(context, listen: false);
    if (stats.selectedCountry == country) {
      return;
    }
    stats.isLoading = true;
    stats.selectedCountry = country;
    stats.selectedTab = 0;
    stats.update().then((value) {
      setState(() {
        isLoading = false;
      });
      stats.isLoading = false;
    });

    setState(() {
      isLoading = true;
      _selected = [true, false];
      _selectedIndex = 0;
    });
  }

  Widget _getTabButton({String label, int index}) {
    return Container(
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: _selectedIndex == index ? Colors.white : Colors.black87,
        ),
      ),
      width: 100,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CovidAppBar(
          selectedTabIndex: _selectedIndex,
          updateStatsFn: (value) => updateStatsForAnotherCountry(value),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16),
              height: 36,
              child: ToggleButtons(
                onPressed: (selected) {
                  updateSelectedTabItem(selected);
                },

                selectedColor: Colors.blue,
                color: Colors.black54,
                selectedBorderColor: Color.fromRGBO(74, 178, 251, 1),
                fillColor: Color.fromRGBO(
                    74, 178, 251, 1), //Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(100),
                isSelected: _selected, // [true, false, false],
                children: <Widget>[
                  _getTabButton(label: 'Today', index: 0),
                  _getTabButton(label: 'Yesterday', index: 1),
                ],
              ),
            ),
            Statistics(),
            Chart(
              data: stats == null ? null : stats.getWeeklyStats(),
            ),
          ],
        ),
      ),
    );
  }
}
