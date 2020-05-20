import 'package:covid19app/model/covid_stats.dart';
import 'package:covid19app/model/weekly_covid_stats.dart';
import 'package:covid19app/widgets/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Chart extends StatelessWidget {
  final List<CovidStats> data;
  // bool isLoading;
  Chart({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: double.infinity,
      alignment: Alignment.center,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getTitle('Daily Active Cases'),
          _getChartContainer(context),
        ],
      ),
    );
  }

  Widget _getChart() {
    return BarChartSample3(Color.fromRGBO(248, 92, 91, 1), data);
  }

  Widget _getChartContainer(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);
    bool isLoading = stats == null ? true : stats.isLoading;
    // data == null ? true : false;
    return Container(
      padding: EdgeInsets.only(top: 16),
      width: double.infinity,
      height: 240,
      child: Card(
        child: isLoading
            ? Center(
                child: Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              )
            : _getChart(),
        elevation: 24,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _getTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black87),
      ),
    );
  }
}
