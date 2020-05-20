import 'package:covid19app/model/covid_stats.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartSample3 extends StatelessWidget {
  final Color barColor;
  final List<CovidStats> data;
  final double maxYValue = 2000;

  BarChartSample3(this.barColor, this.data);

  String generateDayString(int index) {
    int indexLoc = data.length - index - 1;
    String dayString = DateFormat('EEE').format(data[indexLoc].date);
    return dayString;
  }

  List<BarChartGroupData> getWeeklyCases(
      List<CovidStats> covidStatList, Color color) {
    //var tmp = [];
    List<BarChartGroupData> listOfBarGroups = covidStatList
        .map((e) {
          int index = covidStatList.indexOf(e);
          double yVal = e.activeCount.toDouble();
          //tmp.add(yVal);
          return BarChartGroupData(x: index, barRods: [
            BarChartRodData(y: yVal, color: color),
          ], showingTooltipIndicators: [
            0
          ]);
        })
        .toList()
        .reversed
        .toList();

    //tmp.sort();
    //double newMaxYValue = tmp.last;

    return listOfBarGroups;
  }

  String doformat(double value) {
    if (value < 1000) {
      return value.round().toString();
    }
    double result = value / 1000;
    return NumberFormat("###,###,###,###k").format(result.round());
  }

  double getMaxYValue() {
    final List<CovidStats> list = [...data];
    list.sort((a, b) => a.activeCount.compareTo(b.activeCount));
    double max = list.last.activeCount.toDouble();

    if (max < 100) {
      max = max + 10;
    } else if (max < 500) {
      max = max + 100;
    } else if (max < 1000) {
      max = max + 500;
    } else if (max < 5000) {
      max = max + 1000;
    } else if (max < 10000) {
      max = max + 5000;
    } else if (max < 50000) {
      max = max + 10000;
    } else if (max < 100000) {
      max = max + 50000;
    } else if (max < 1000000) {
      max = max + 100000;
    } else {
      max = max + 300000;
    }

    return max;
  }

  @override
  Widget build(BuildContext context) {
    getWeeklyCases(data, barColor);
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        //color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: getMaxYValue(),
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    doformat(rod.y),
                    TextStyle(
                      color: Colors.black87,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    color: const Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return generateDayString(0); //'Mn';
                    case 1:
                      return generateDayString(1); //'Tu';
                    case 2:
                      return generateDayString(2); //'Wd';
                    case 3:
                      return generateDayString(3); //'Th';
                    case 4:
                      return generateDayString(4); //'Fr';
                    case 5:
                      return generateDayString(5); //'St';
                    case 6:
                      return generateDayString(6); //'Sn';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: getWeeklyCases(data, barColor),
          ),
        ),
      ),
    );
  }
}
