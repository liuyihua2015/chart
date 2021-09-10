import 'dart:math';
import 'dart:ui';

import 'package:echart/ChartData.dart';
import 'package:echart/LineChartWidget.dart';
import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  final double width;
  final double height;

  //柱状图的背景颜色
  final Color bgColor;

  //x轴与y轴的颜色
  final Color xyColor;

  //柱状图的颜色
  final Color columnarColor;

  //是否显示x轴与y轴的基准线
  final bool showBaseline;

  //实际的数据
  final List<ChartData>? dataList;

  //控件距离左边的距离
  final int paddingLeft;

  //控件距离顶部的距离
  final int paddingTop;

  //控件距离底部的距离
  final int paddingBottom;

  //标记线的长度
  final int markLineLength;

  //y轴最大值
  final int? maxYValue;

  //y轴之间的间隔
  final double ySpace;

  //y轴 文本标签 间隔多少显
  final double yIntervalValue;

  //x轴最大值
  final int? maxXValue;

  //x轴每列之间的间隔
  final double xSpace;

  //x轴 文本标签 间隔多少显
  final double xIntervalValue;

  //折线的颜色
  final Color polygonalLineColor;

  //x轴所有内容的偏移量
  final double xOffset;

  LineChart(this.width,
      this.height, {
        required this.dataList,
        required this.maxYValue,
        required this.maxXValue,
        this.bgColor = Colors.white,
        this.xyColor = Colors.black,
        this.columnarColor = Colors.blue,
        this.showBaseline = false,
        this.ySpace = 10,
        this.yIntervalValue = 10,
        this.xSpace = 10,
        this.xIntervalValue = 10,
        this.paddingLeft = 30,
        this.paddingTop = 30,
        this.paddingBottom = 30,
        this.markLineLength = 0,
        this.polygonalLineColor = Colors.blue,
        this.xOffset = 0,
      });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  double xOffset = 0;

  @override
  void initState() {
    xOffset = widget.xOffset;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onHorizontalDragUpdate: (DragUpdateDetails details) {
    //     //        print("DragUpdateDetails");
    //     setState(() {
    //       xOffset += details.primaryDelta!;
    //     });
    //   },
    //   onHorizontalDragDown: (DragDownDetails details) {
    //     print("onHorizontalDragDown");
    //   },
    //   onHorizontalDragCancel: () {
    //     print("onHorizontalDragCancel");
    //   },
    //   onHorizontalDragEnd: (DragEndDetails details) {
    //     print("onHorizontalDragEnd");
    //   },
    //   onHorizontalDragStart: (DragStartDetails details) {
    //     print("onHorizontalDragStart");
    //   },
    //   child:
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: LineChartWidget(
        linePaint: Paint(),
        bgColor: widget.bgColor,
        xyColor: widget.xyColor,
        showBaseline: widget.showBaseline,
        dataList: widget.dataList!,
        maxYValue: widget.maxYValue!,
        ySpace: widget.ySpace,
        yIntervalValue: widget.yIntervalValue,
        maxXValue: widget.maxXValue!,
        xSpace: widget.xSpace,
        xIntervalValue: widget.xIntervalValue,
        paddingLeft: widget.paddingLeft,
        paddingTop: widget.paddingTop,
        paddingBottom: widget.paddingBottom,
        markLineLength: widget.markLineLength,
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Test(),
    ),
  );
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late List<ChartData> dataList = [];

  setData() {
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    for (double i = 0; i <= 4800; i++) {
      if (i > 3000 && i < 4000) {
        // dataList.add(ChartData(i, 0));
      } else {
        // dataList.add(ChartData(i, next(100, 200).toDouble()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    if (dataList.length <= 0) {
      setData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("自定义折线图"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics:ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: 1060,//宽度+左右padding
            height: 240,//高度+上下padding
            child: LineChart(
              size.width,
              240,
              bgColor: Colors.white,
              xyColor: Colors.grey,

              paddingTop: 30,
              paddingBottom: 10,
              paddingLeft: 30,

              markLineLength: 10,

              showBaseline: true,

              maxYValue: 200,
              ySpace: 10,
              yIntervalValue:40,

              maxXValue: 1000,
              xSpace: 10,
              xIntervalValue:50,


              // xOffset: 10,
              dataList: dataList,
            ),
          ),
        ),
      ),
    );
  }
}
