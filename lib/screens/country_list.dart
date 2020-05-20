import 'package:covid19app/model/covid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryList extends StatelessWidget {
  static const routeName = 'countries';
  final String selectedCountry;
  CountryList({this.selectedCountry});

  Widget _buildListView(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    List popularCountries = [
      'United States of America',
      'United Kingdom',
      'Germany',
      'Italy',
      'Spain',
      'Turkey',
      'China',
    ];
    popularCountries.removeWhere((element) => element == selectedCountry);

    List countryNames = snapshot.data;
    countryNames.removeWhere((element) => element == selectedCountry);
    countryNames.removeWhere((element) => popularCountries.contains(element));

    countryNames = [selectedCountry, ...popularCountries, ...countryNames];
    // print(countryNames);

    return ListView.separated(
      itemCount: countryNames.length,
      separatorBuilder: (context, index) => index == popularCountries.length
          ? Divider(
              thickness: 1.6,
              color: Colors.black45,
            )
          : Divider(),
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.of(context).pop(countryNames[index]);
        },
        title: Text(
          countryNames[index],
          style: countryNames[index] == selectedCountry
              ? GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.bold)
              : GoogleFonts.lato(),
        ),
        trailing: countryNames[index] == selectedCountry
            ? Icon(
                Icons.check,
                color: Colors.red,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var covid = Covid();
    covid.getCountries();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.black87,
            ),
        title: Text(
          'Select Another Country',
          style: GoogleFonts.lato(
            color: Colors.black87,
          ),
        ),
      ),
      body: FutureBuilder(
        future: covid.getCountries(),
        builder: (context, snapshot) => _buildListView(snapshot),

        /* ListView(
          children: <Widget>[
            ListTile(
              title: Text('Turkey'),
            ),
            ListTile(
              title: Text('USA'),
            ),
            ListTile(
              title: Text('UK'),
            ),
            ListTile(
              title: Text('Germany'),
            ),
            ListTile(
              title: Text('Italy'),
            ),
          ],
        ),*/
      ),
    );
  }
}
