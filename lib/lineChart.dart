import 'dart:ui';
import 'package:echart/chartData.dart';
import 'package:echart/chartFixedYLineWidget.dart';
import 'package:echart/chartPathWidget.dart';
import 'package:echart/chartLineWidget.dart';
import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  final double width;
  final double height;

  //柱状图的背景颜色
  final Color bgColor;

  //左右固定Y数值widght背景颜色
  final Color fixedYLineBgColor;

  //x轴与y轴的颜色
  final Color xyColor;

  //柱状图的颜色
  final Color columnarColor;

  //是否显示x轴与y轴的基准线
  final bool showBaseline;

  //第一条曲线数据
  final List<ChartData> firstDataList;

  //第二条曲线数据 最多两条数据
  final List<ChartData>? secondDataList;

  //第一条线的阈值范围 （min，max）
  final Offset firstPathThresholdOffset;

  //控件距离左边的距离
  final int paddingLeft;

  //控件距离右边的距离
  final int paddingRight;

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

  //指定背景范围
  final Offset specifiesBgOffset;

  //指定背景颜色
  final Color specifiesBgColor;

  LineChart(
    this.width,
    this.height, {
    required this.maxYValue,
    required this.maxXValue,
    required this.firstDataList,
    this.secondDataList,
    this.bgColor = Colors.white,
    this.xyColor = Colors.black,
    this.columnarColor = Colors.blue,
    this.showBaseline = false,
    this.ySpace = 10,
    this.yIntervalValue = 10,
    this.xSpace = 10,
    this.xIntervalValue = 10,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.valueLineSpace = 10,
    this.polygonalLineColor = Colors.blue,
    this.specifiesBgOffset = const Offset(0, 0),
    this.firstPathThresholdOffset = const Offset(80, 200),
    this.specifiesBgColor = Colors.green,
    this.fixedYLineBgColor = Colors.white,
  });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  Widget createLayers(List<CustomPainter> painters,
      [Widget child = const SizedBox.expand()]) {
    painters.reversed.forEach((painter) {
      child = RepaintBoundary(
        child: CustomPaint(
          painter: painter,
          child: child,
        ),
      );
    });
    return child;
  }

  CustomPainter customPaintWidget() {
    return ChartPathWidget(
      showBaseline: widget.showBaseline,
      firstDataList: widget.firstDataList,
      secondDataList: widget.secondDataList,
      maxYValue: widget.maxYValue!,
      paddingRight: widget.paddingRight,
      paddingLeft: widget.paddingLeft,
      paddingTop: widget.paddingTop,
      paddingBottom: widget.paddingBottom,
      firstPathThresholdOffset: widget.firstPathThresholdOffset,
    );
  }

  CustomPainter customPaintLineWidget() {
    return ChartLineWidget(
      specifiesBgColor: widget.specifiesBgColor,
      specifiesBgOffset: widget.specifiesBgOffset,
      bgColor: widget.bgColor,
      xyColor: widget.xyColor,
      showYAxis: false,
      showBaseline: widget.showBaseline,
      maxYValue: widget.maxYValue!,
      ySpace: widget.ySpace,
      yIntervalValue: widget.yIntervalValue,
      maxXValue: widget.maxXValue!,
      xSpace: widget.xSpace,
      xIntervalValue: widget.xIntervalValue,
      paddingLeft: widget.paddingLeft,
      paddingRight: widget.paddingRight,
      paddingTop: widget.paddingTop,
      paddingBottom: widget.paddingBottom,
      valueLineSpace: widget.valueLineSpace,
    );
  }

  CustomPainter customChartFixedYLineWidget(bool isRight) {
    return ChartFixedYLineWidget(
      bgColor: widget.fixedYLineBgColor,
      maxYValue: widget.maxYValue!,
      ySpace: widget.ySpace,
      yIntervalValue: widget.yIntervalValue,
      paddingLeft: widget.paddingLeft,
      paddingRight: widget.paddingRight,
      paddingTop: widget.paddingTop,
      paddingBottom: widget.paddingBottom,
      valueLineSpace: widget.valueLineSpace,
      isRightWidget: isRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(alignment: Alignment.center, children: <Widget>[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                width: 1000, //宽度+左右padding
                height: 260, //高度+上下padding
                child: createLayers(
                    [customPaintLineWidget(), customPaintWidget()]))),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 40,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: customChartFixedYLineWidget(false),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 40,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: customChartFixedYLineWidget(true),
            ),
          ),
        )
      ]),
    );
  }
}
