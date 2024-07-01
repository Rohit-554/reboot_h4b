import 'dart:convert';
import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tiktik_v/presentation/pie_chart.dart';

Map<String, dynamic> convertStringToMap(String jsonString) {
  return jsonDecode(jsonString);
}

class AnalyzePage extends StatefulWidget {
  final String dataPointsBundle;
  AnalyzePage({required this.dataPointsBundle});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();

    data = convertStringToMap(widget.dataPointsBundle);
    print("This is data bundle: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1b2339),
      appBar: AppBar(
        title: Text('Analyze Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.dataPointsBundle.isNotEmpty
              ? BarChartSample1(data: data) // Assuming dataList holds data for BarChart
              : Column(
                children: [
                  _showCharts(),
                ],
              )
        ),
      ),
    );
  }

  Widget _showCharts(){
    return Image.asset("assets/ij.png");
   /* print("andar ai");
    return Row(
      children: [
        Center(child: PieChartSample2(values: dataList, productName: productNames)),
      ],
    );*/
  }

  Map<String, dynamic> generateRandomMap() {
    final random = Random();
    List<String> selectedProducts = productNames.sublist(0, 6); // Selecting first 8 products

    Map<String, dynamic> randomMap = {};
    for (String productName in selectedProducts) {
      double totalRevenue = 5000 + random.nextDouble() * 3000;
      int sale = random.nextInt(5000); // Assuming sale range from 0 to 5000
      randomMap[productName] = {
        'total_revenue': totalRevenue,
        'sale': sale,
      };
    }

    return randomMap;
  }

}

List<String> productNames = [
  "Field & Stream Sportsman 16 Gun Fire Safe",
  "Perfect Fitness Perfect Rip Deck",
  "Diamondback Women's Serene Classic Comfort Bi",
  "Fitbit Zip Wireless Activity Tracker",
  "OontZ Angle 3 Portable Bluetooth Speaker",
  "AmazonBasics 15.6-Inch Laptop and Tablet Bag"
];




class BarChartSample1 extends StatefulWidget {
  final Map<String, dynamic> data;

  BarChartSample1({required this.data});

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    List<String> productNames = widget.data.keys.toList();
    List<double> revenues = widget.data.values
        .map((item) => Decimal.parse(item['total_revenue'].toString()).toDouble())
        .toList();
    List<double> sales = widget.data.values
        .map((item) => Decimal.parse(item['sale'].toString()).toDouble())
        .toList();

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Sales Data',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Revenue and Sales',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2), // Adjust opacity for glass effect
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3), // Box shadow with opacity
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: buildBarChart(productNames, revenues, 'Total Revenue'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2), // Adjust opacity for glass effect
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Box shadow with opacity
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text("Total Sales",style: TextStyle(fontWeight: FontWeight.bold),),
                            Center(
                              child: PieChartSample2(values: sales, productName: productNames),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      refreshState();
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBarChart(List<String> productNames, List<double> data, String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 200, // Specify a height for the BarChart
          child: BarChart(
            isPlaying ? randomData() : mainBarData(productNames, data),
            swapAnimationDuration: animDuration,
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.black,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellowAccent.withOpacity(0.5))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100000,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<double> data) =>
      List.generate(data.length, (i) {
        return makeGroupData(i, data[i], isTouched: i == touchedIndex);
      });

  BarChartData mainBarData(List<String> productNames, List<double> data) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              productNames[group.x.toInt()] + '\n',
              TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8,
                child: Text(
                  productNames[value.toInt()],
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(data),
      gridData: const FlGridData(show: false),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8,
                child: Text(''),
              );
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        return makeGroupData(
          i,
          (1000 * (i + 1)).toDouble(),
          barColor: Colors.black,
        );
      }),
      gridData: const FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}


