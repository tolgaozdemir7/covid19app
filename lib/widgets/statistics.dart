import 'package:covid19app/model/weekly_covid_stats.dart';
import 'package:covid19app/widgets/covid_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Statistics extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getTitle('Statistics'),
          SizedBox(height: 24),
          Expanded(child: _getFirstRow(context)),
          SizedBox(height: 16),
          Expanded(child: _getSecondRow(context)),
        ],
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

  Widget _getFirstRow(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);

    final String affectedContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].affectedCount.toString();
    final String deathContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].deathCount.toString();
    final String newDeathContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].newDeaths.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CovidCard(
          color: Color.fromRGBO(252, 187, 75, 1),
          title: 'Affected',
          content: affectedContent,
        ),
        SizedBox(
          width: 16,
        ),
        CovidCard(
          color: Color.fromRGBO(252, 88, 89, 1),
          title: 'Death',
          newCases: newDeathContent,
          fontSize: 26,
          content: deathContent,
        ),
      ],
    );
  }

  Widget _getSecondRow(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);

    final String recoveredContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].recoveredCount.toString();
    final String activeContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].activeCount.toString();
    final String seriousContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].seriousCount.toString();
    final String newActiveContent = stats == null
        ? ""
        : stats.weeklyStats[stats.selectedTab].newActiveCases.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CovidCard(
          color: Color.fromRGBO(75, 214, 122, 1),
          title: 'Recovered',
          fontSize: 16,
          content: recoveredContent,
        ),
        SizedBox(
          width: 16,
        ),
        CovidCard(
          color: Color.fromRGBO(74, 178, 251, 1),
          title: 'Active',
          fontSize: 16,
          newCases: newActiveContent,
          content: activeContent,
        ),
        SizedBox(
          width: 16,
        ),
        CovidCard(
          color: Color.fromRGBO(129, 88, 251, 1),
          title: 'Serious',
          fontSize: 16,
          content: seriousContent,
        ),
      ],
    );
  }
}
