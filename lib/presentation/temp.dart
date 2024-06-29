import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class SalesData {
  final String productName;
  final int totalUnitsSold;
  final double revenueGenerated;
  final double totalMargin;

  SalesData({
    required this.productName,
    required this.totalUnitsSold,
    required this.revenueGenerated,
    required this.totalMargin,
  });

  factory SalesData.fromJson(String name, Map<String, dynamic> json) {
    return SalesData(
      productName: name,
      totalUnitsSold: json['total_units_sold'].toInt(),
      revenueGenerated: json['revenue_generated'],
      totalMargin: json['total_margin'],
    );
  }
}

class SalesBarChart extends StatelessWidget {
  final List<SalesData> data;

  SalesBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data
            .asMap()
            .map((index, salesData) => MapEntry(
            index,
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(fromY: salesData.totalUnitsSold.toDouble(), color: Colors.green, toY: 2.0)
              ],
              showingTooltipIndicators: [0],
            )))
            .values
            .toList(),
      ),
    );
  }
}

void main() {
  Map<String, dynamic> rawData = {
    'Field & Stream Sportsman 16 Gun Fire Safe': {'total_units_sold': 5645, 'revenue_generated': 2257887.1620178223, 'total_margin': 0.0},
    'Perfect Fitness Perfect Rip Deck': {'total_units_sold': 24363, 'revenue_generated': 1461536.4108772278, 'total_margin': -0.0000152587890625},
    "Diamondback Women's Serene Classic Comfort Bi": {'total_units_sold': 4517, 'revenue_generated': 1355009.7096252441, 'total_margin': 0.0},
  };

  List<SalesData> salesData = rawData.entries.map((entry) => SalesData.fromJson(entry.key, entry.value)).toList();

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Sales Bar Chart')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SalesBarChart(data: salesData),
        ),
      ),
    ),
  ));
}
