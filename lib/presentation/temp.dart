import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Markdown Table'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomMarkdownTable(),
        ),
      ),
    );
  }
}

class CustomMarkdownTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const markdownData = """
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
|   Row 1  |   Row 1  |   Row 1  |
|   Row 2  |   Row 2  |   Row 2  |
|   Row 3  |   Row 3  |   Row 3  |
""";

    return Markdown(
      data: markdownData,
      styleSheet: MarkdownStyleSheet(
        tableBorder: TableBorder.all(borderRadius: BorderRadius.circular(5),color: Colors.grey,style: BorderStyle.solid,width: 1),
        tableVerticalAlignment: TableCellVerticalAlignment.middle,
        tableHead: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),

        tableBody: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        tableCellsDecoration: BoxDecoration(color: Colors.yellow),
        tableHeadAlign: TextAlign.center,
        // tableColumnWidth: FixedColumnWidth(120.0),
      ),
    );
  }
}
