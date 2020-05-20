import 'package:covid19app/model/weekly_covid_stats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CovidCard extends StatelessWidget {
  final Color color;
  final String title;
  final String content;
  final String newCases;
  final double fontSize;

  CovidCard(
      {this.color, this.title, this.content, this.newCases, this.fontSize});

  String doformat(String value) {
    if (value == "0") return "Unknown";
    return NumberFormat("###,###,###,###").format(int.parse(value));
  }

  String formatNewStats(String value) {
    return int.parse(value) > 0 ? '+' + doformat(value) : doformat(value);
  }

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);
    bool isLoading = stats == null ? true : stats.isLoading;
    // bool isLoading = content == "" ? true : false;

    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize ?? 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(bottom: 8),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        backgroundColor: Colors.white.withOpacity(.6),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        if (newCases != null)
                          FittedBox(
                            child: Text(
                              formatNewStats(newCases),
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Colors.white.withOpacity(.6),
                                  fontSize: fontSize ?? 26,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        FittedBox(
                          child: Text(
                            doformat(content),
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize ?? 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        //height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
