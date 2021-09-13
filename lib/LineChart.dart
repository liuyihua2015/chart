
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

  //数值和表之间距离
  final int valueLineSpace;

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

  final GlobalKey globalKey;

  LineChart(
    this.width,
    this.height, {
    required this.maxYValue,
    required this.maxXValue,
    required this.globalKey,
    required this.dataList,
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
    this.valueLineSpace = 10,
    this.polygonalLineColor = Colors.blue,
  });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  late List<ChartData> dataList = [];

  @override
  void initState() {
    super.initState();
  }

  double xOffset = 0;

  //
  // @override
  // void initState() {
  //   super.initState();
  //   // _pathController.addPathData!();
  // }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        // key: widget.globalKey,
        isComplex: true,
        willChange: true,
        size: Size(widget.width, widget.height),
        painter: LineChartWidget(
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
          valueLineSpace: widget.valueLineSpace,
        ),
      ),
    );
  }
}
