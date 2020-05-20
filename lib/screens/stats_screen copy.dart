// DONE: Loading için ilgili görselleri kullan
// DONE: Tab sayısını 2'ye düşür
// DONE: Grafiği düzenle ve kullanıma hazırla
// DONE: Ekran yüksekliğini dinamik olarak ayarla
// TODO: Farklı ülkelerin datasını kullanmaya başla
/*
import 'package:covid19app/model/covid.dart';
import 'package:covid19app/widgets/app_bar.dart';
import 'package:covid19app/widgets/chart.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String selectedCountry = "Turkey";
  //
  final covid = Covid();
  CovidStats covidStats;

  void setSelectedItem(int selectedItemIndex) {
    var newSelectedList = List<bool>.generate(
        2, (index) => index == selectedItemIndex ? true : false);
    setState(() {
      _selected = newSelectedList;
      _selectedIndex = selectedItemIndex;
    });
  }

  Future<List<CovidStats>> getStats() async {
    return await covid.getCovidTimeSeries(selectedCountry);
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

  void updateStats(String value) {
    // print('updateStats is called.');
    setState(() {
      selectedCountry = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            isLoading = true;
          } else if (snapshot.connectionState == ConnectionState.done) {
            isLoading = false;
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: isLoading
                  ? CovidAppBar(
                      label: '...',
                      dateString: null,
                      isLoading: isLoading,
                    )
                  : CovidAppBar(
                      label: snapshot.data[_selectedIndex].country,
                      dateString: snapshot.data[_selectedIndex].date,
                      isLoading: isLoading,
                      updateStatsFn: updateStats,
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
                        setSelectedItem(selected);
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
                  Statistics(
                      isLoading: isLoading,
                      data: isLoading ? null : snapshot.data[_selectedIndex]),
                  Chart(
                    snapshot.data,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
*/
