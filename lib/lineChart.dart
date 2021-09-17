import 'dart:ui';
import 'package:echart/chartData.dart';
import 'package:echart/chartFixedYLineWidget.dart';
import 'package:echart/chartPathWidget.dart';
import 'package:echart/chartLineWidget.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
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
  final int maxYValue;

  //x轴时间最大值(秒)
  final int maxSeconds;

  //y轴之间的间隔
  final double ySpace;

  //y轴 文本标签 间隔多少显
  final double yIntervalValue;

  //x轴最大值
  final int maxXValue;

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

  //第一条曲线数据
  late List<ChartData>? _firstDataList;

  //第二条曲线数据 最多两条数据
  late List<ChartData>? _secondDataList;

  //屏幕size
  double? _screenWidth;

  //scrollView是否自己滚动
  late bool _scrollViewIsRolling;

  LineChartWidget(
    this.width,
    this.height, {
    required this.maxYValue,
    required this.maxXValue,
    required this.maxSeconds,
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
    Key? key,
  }) : super(key: key) {
    _firstDataList = [];
    _secondDataList = [];
    _scrollViewIsRolling = true;
  }

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  ScrollController _scrollController = ScrollController();

  ///更新数据
  void updataDataList(List<ChartData>? firstList, List<ChartData>? secondList) {
    setState(() {
      if (firstList != null) {
        //数据赋值
        widget._firstDataList = firstList;
        if (secondList != null) {
          widget._secondDataList = secondList;
        }
        //自动滚动
        if (widget._scrollViewIsRolling) {
          double currentWidth =
              firstList.length ~/ 4.0 * (widget.maxXValue / widget.maxSeconds);
          double chartHalfWidth = (widget.width.toDouble() - 40 - 50) * 0.5;
          double offset = 0;
          if (currentWidth > chartHalfWidth) {
            offset = currentWidth - chartHalfWidth;
          }
          _scrollController.animateTo(offset,
              duration: Duration(milliseconds: 300), curve: Curves.easeInCirc);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print("object");
    _scrollController.addListener(() {
      // 打印位置监听数据
      // print("lister = ${_scrollController.offset}");

      //   // 滚动到起始位置
      //   _scrollController.animateTo(0, duration: Duration(seconds: 2), curve: Curves.easeInCirc);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

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
      firstDataList: widget._firstDataList,
      secondDataList: widget._secondDataList,
      maxYValue: widget.maxYValue,
      maxXValue: widget.maxXValue,
      maxSeconds: widget.maxSeconds,
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
      maxYValue: widget.maxYValue,
      ySpace: widget.ySpace,
      yIntervalValue: widget.yIntervalValue,
      maxXValue: widget.maxXValue,
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
      maxYValue: widget.maxYValue,
      ySpace: widget.ySpace,
      yIntervalValue: isRight ? 20 : widget.yIntervalValue,
      paddingLeft: widget.paddingLeft,
      paddingRight: widget.paddingRight,
      paddingTop: widget.paddingTop,
      paddingBottom: widget.paddingBottom,
      valueLineSpace: isRight ? 5 : widget.valueLineSpace,
      isRightWidget: isRight,
      yAxisMarkValueSuffix: isRight ? "%" : "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(alignment: Alignment.center, children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: (scrollState) {
            if (scrollState is ScrollEndNotification) {
              Future.delayed(const Duration(milliseconds: 3000), () {})
                  .then((s) {
                widget._scrollViewIsRolling = true;
              });
            } else if (scrollState is ScrollStartNotification) {
              widget._scrollViewIsRolling = false;
            }
            return false;
          },
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(40, 0, 50, 0),
                  width: (widget.maxXValue +
                          widget.paddingLeft +
                          widget.paddingRight)
                      .toDouble(), //宽度+左右padding
                  height: (widget.maxYValue +
                          widget.paddingTop +
                          widget.paddingBottom)
                      .toDouble(), //高度+上下padding
                  child: createLayers(
                      [customPaintLineWidget(), customPaintWidget()]))),
        ),
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
