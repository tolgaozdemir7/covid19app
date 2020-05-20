import 'package:covid19app/model/weekly_covid_stats.dart';
import 'package:covid19app/screens/country_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CovidAppBar extends StatelessWidget {
  final Function updateStatsFn;
  final int selectedTabIndex;

  CovidAppBar({this.selectedTabIndex = 0, this.updateStatsFn});

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<WeeklyCovidStats>(context);

    return AppBar(
      centerTitle: true,
      title: stats == null
          ? Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
              ),
            )
          : GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryList(selectedCountry: stats.selectedCountry),
                    fullscreenDialog: true,
                  ),
                );
                if (result == null) return;

                updateStatsFn(result);
                // stats.selectedCountry = result;

                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('Selected country: $result'),
                  ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: Colors.black87,
                        size: 18,
                      ),
                      Text(
                        stats.selectedCountry,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('d MMMM y, E')
                        .format(stats.weeklyStats[selectedTabIndex].date)
                        .toString(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      brightness: Brightness.light,
    );
  }
}
