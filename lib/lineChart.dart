import 'dart:ui';
import 'package:echart/model/fhrChartModel.dart';
import 'package:echart/chartFixedYLineWidget.dart';
import 'package:echart/chartPathWidget.dart';
import 'package:echart/chartLineWidget.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  final FhrChartModel fhrChartModel;

  //第一条曲线数据
  late List<ChartData>? _firstDataList;

  //第二条曲线数据 最多两条数据
  late List<ChartData>? _secondDataList;

  LineChartWidget(Key? key, this.fhrChartModel) : super(key: key) {
    _firstDataList = [];
    _secondDataList = [];
  }

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  ScrollController _scrollController = ScrollController();

  int pointCount = 0;

  ///添加更新曲线数据
  void addDataList({List<int>? firstList, List<int>? secondList}) {
    if (firstList != null && firstList.length != 0) {
      pointCount = firstList.length;
      for (var d in firstList) {
        ChartData data = ChartData(
            widget._firstDataList!.length / firstList.length, d.toDouble());
        widget._firstDataList!.add(data);
      }
    }
    if (secondList != null && secondList.length != 0) {
      pointCount = secondList.length;
      for (var d in secondList) {
        ChartData data = ChartData(
            widget._secondDataList!.length / secondList.length, d.toDouble());
        widget._secondDataList!.add(data);
      }
    }
    //自动滚动
    if (widget.fhrChartModel.scrollViewIsRolling) {
      if (pointCount != 0) {
        double currentWidth = widget._firstDataList!.length ~/
            pointCount *
            (widget.fhrChartModel.maxXValue / widget.fhrChartModel.times);
        double chartHalfWidth = (widget.fhrChartModel.width.toDouble() -
                widget.fhrChartModel.lineChartPaddingLeft.toDouble() -
                widget.fhrChartModel.lineChartPaddingRight.toDouble()) *
            0.5;
        double offset = 0;
        if (currentWidth > chartHalfWidth) {
          offset = currentWidth - chartHalfWidth;
        }
        _scrollController.animateTo(offset,
            duration: Duration(milliseconds: 300), curve: Curves.easeInCirc);
      }
    }
    setState(() {});
  }

  ///重置全部数据
  void resetAllDates() {
    widget._firstDataList = [];
    widget._secondDataList = [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
      showBaseline: widget.fhrChartModel.showBaseline,
      firstDataList: widget._firstDataList,
      secondDataList: widget._secondDataList,
      maxYValue: widget.fhrChartModel.maxYValue,
      maxXValue: widget.fhrChartModel.maxXValue,
      times: widget.fhrChartModel.times,
      paddingRight: widget.fhrChartModel.paddingRight,
      paddingLeft: widget.fhrChartModel.paddingLeft,
      paddingTop: widget.fhrChartModel.paddingTop,
      paddingBottom: widget.fhrChartModel.paddingBottom,
      firstPathThresholdOffset: widget.fhrChartModel.firstPathThresholdOffset,
      secondNumberProportion: widget.fhrChartModel.secondNumberProportion,
      firstPathLineWidth: widget.fhrChartModel.firstPathLineWidth,
      secondPathLineWidth: widget.fhrChartModel.secondPathLineWidth,
      firstPathLineColor: widget.fhrChartModel.firstPathLineColor,
      secondPathLineColor: widget.fhrChartModel.secondPathLineColor,
    );
  }

  CustomPainter customPaintLineWidget() {
    return ChartLineWidget(
      specifiesBgColor: widget.fhrChartModel.specifiesBgColor,
      specifiesBgOffset: widget.fhrChartModel.specifiesBgOffset,
      bgColor: widget.fhrChartModel.bgColor,
      xyColor: widget.fhrChartModel.xyColor,
      showYAxis: widget.fhrChartModel.lineChartPaddingLeft <= 0,
      showBaseline: widget.fhrChartModel.showBaseline,
      maxYValue: widget.fhrChartModel.maxYValue,
      ySpace: widget.fhrChartModel.ySpace,
      yIntervalValue: widget.fhrChartModel.yIntervalValue,
      maxXValue: widget.fhrChartModel.maxXValue,
      xSpace: widget.fhrChartModel.xSpace,
      xIntervalValue: widget.fhrChartModel.xIntervalValue,
      paddingLeft: widget.fhrChartModel.lineChartPaddingLeft > 0
          ? 0
          : widget.fhrChartModel.paddingLeft,
      paddingRight: widget.fhrChartModel.lineChartPaddingRight > 0
          ? 0
          : widget.fhrChartModel.paddingRight,
      paddingTop: widget.fhrChartModel.paddingTop,
      paddingBottom: widget.fhrChartModel.paddingBottom,
      valueLineSpace: widget.fhrChartModel.valueLineSpace,
      textColor: widget.fhrChartModel.textColor,
      textFontSize: widget.fhrChartModel.textFontSize,
    );
  }

  CustomPainter customChartFixedYLineWidget(bool isRight) {
    return ChartFixedYLineWidget(
      bgColor: widget.fhrChartModel.fixedYLineBgColor,
      maxYValue: widget.fhrChartModel.maxYValue,
      ySpace: widget.fhrChartModel.ySpace,
      yIntervalValue: isRight ? 20 : widget.fhrChartModel.yIntervalValue,
      paddingLeft: widget.fhrChartModel.paddingLeft,
      paddingRight: widget.fhrChartModel.paddingRight,
      paddingTop: widget.fhrChartModel.paddingTop,
      paddingBottom: widget.fhrChartModel.paddingBottom,
      valueLineSpace: isRight ? 5 : widget.fhrChartModel.valueLineSpace,
      isRightWidget: isRight,
      yAxisMarkValueSuffix: isRight ? "%" : "",
      displayOffset: isRight ? Offset(0, 40) : Offset(0, 0),
      numberProportion: isRight
          ? widget.fhrChartModel.secondNumberProportion
          : widget.fhrChartModel.firstNumberProportion,
      textColor: widget.fhrChartModel.textColor,
      textFontSize: widget.fhrChartModel.textFontSize,
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
                widget.fhrChartModel.scrollViewIsRolling = true;
              });
            } else if (scrollState is ScrollStartNotification) {
              widget.fhrChartModel.scrollViewIsRolling = false;
            }
            return false;
          },
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      widget.fhrChartModel.lineChartPaddingLeft.toDouble(),
                      0,
                      widget.fhrChartModel.getLineChartPaddingRight +
                          widget.fhrChartModel.valueLineSpace.toDouble(),
                      0),
                  width: (widget.fhrChartModel.maxXValue +
                          widget.fhrChartModel.paddingLeft +
                          widget.fhrChartModel.paddingRight)
                      .toDouble(), //宽度+左右padding
                  height: (widget.fhrChartModel.maxYValue +
                          widget.fhrChartModel.paddingTop +
                          widget.fhrChartModel.paddingBottom)
                      .toDouble(), //高度+上下padding
                  child: createLayers(
                      [customPaintLineWidget(), customPaintWidget()]))),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: widget.fhrChartModel.lineChartPaddingLeft.toDouble(),
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
          width: widget.fhrChartModel.getLineChartPaddingRight,
          child: widget.fhrChartModel.hiddenRightYAxis
              ? Container(
                  color: widget.fhrChartModel.fixedYLineBgColor,
                )
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: customChartFixedYLineWidget(true),
                  ),
                ),
        )
      ]),
    );
  }
}
