import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('chart'),

      ),
      // body: Container(
      //   child: LineChart(
      //     size.width,
      //     300,
      //     bgColor: Colors.red,
      //     xOffset: 10,
      //     showBaseline: true,
      //     maxYValue: 600,
      //     yCount: 6,
      //     dataList: [
      //       ChartData("Data A", 100),
      //       ChartData("Data B", 300),
      //       ChartData("Data C", 200),
      //       ChartData("Data D", 500),
      //       ChartData("Data E", 450),
      //       ChartData("Data F", 230),
      //       ChartData("Data G", 270),
      //       ChartData("Data H", 170),
      //     ],
      //   ),
      // ),
      //
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            color: Color(0xFFEDECED),
            child: Stack(children: <Widget>[
              Positioned(
                top: 40,
                child: Container(
                  height: 40,
                  width: 1000,
                  color: Color(0xFF97E2D6),
                ),
              ),
              CustomPaint(
                size: Size(1000, 200), //指定画布大小
                painter: MyPainter(),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //画背景
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 0.5
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..invertColors = false;

    double rowLineCount = size.height / 10.0;
    for (int i = 0; i < rowLineCount + 1; i++) {
      double y = i * 10.0;
      paint..strokeWidth = (i % 4 == 0) ? 0.5 : 0.3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    double colLineCount = size.width / 10.0;
    for (int i = 0; i < colLineCount + 1; i++) {
      double x = i * 10.0;
      paint..strokeWidth = (i % 5 == 0) ? 0.5 : 0.3;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }


// var  _fhrPath = Path();
//     _fhrPath.cubicTo(
//         size.width / 4,
//         3 * size.height / 4,
//         3 * size.width / 4,
//         size.height / 4,
//         size.width,
//         size.height);

    // _fhrPath.close();



    // _fhrPath.addPolygon([
    //   // Offset(100.0, 100.0),
    //   // Offset(200.0, 200.0),
    //   // Offset(100.0, 300.0),
    //   // Offset(150.0, 350.0),
    //   // Offset(150.0, 500.0),
    //   Offset.zero,
    //   Offset(size.width / 4, size.height / 4),
    //   Offset(size.width / 2, size.height)
    // ], false);

    // _fhrPath.moveTo(100.0, 100.0);
    //
    // _fhrPath.lineTo(200.0, 200.0);
    // _fhrPath.lineTo(100.0, 300.0);
    // _fhrPath.lineTo(150.0, 350.0);
    // _fhrPath.lineTo(150.0, 500.0);

    // _fhrPath.cubicTo(
    //     size.width / 4,
    //     3 * size.height / 4,
    //     3 * size.width / 4,
    //     size.height / 4,
    //     size.width,
    //     size.height);

    // _fhrPath.close();
    //
    // canvas.drawPath(_fhrPath, paint);
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
