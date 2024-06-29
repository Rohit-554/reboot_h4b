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
{code: 
sql
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.order_item_quantity * oi.order_item_product_price) AS total_revenue
FROM 
    products p
JOIN 
    order_items oi ON p.product_id = oi.order_item_product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_revenue DESC
LIMIT 1;
, message: Based on the query result provided, it appears that the product with product_id 1004, named "Field & Stream Sportsman 16 Gun Fire Safe," generated a total revenue of 6929653.690338135 units. Therefore, based on this result, the product "Field & Stream Sportsman 16 Gun Fire Safe" is the best performing product in terms of revenue.
, table: 
| product_id | product_name | total_revenue |
| --- | --- | --- |
| 1004 | Field & Stream Sportsman 16 Gun Fire Safe | 6929653.690338135|
}
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
