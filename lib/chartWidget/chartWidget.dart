import 'dart:ui';
import 'package:echart/chartWidget/model/chartModel.dart';
import 'package:echart/chartWidget/chartFixedYLineWidget.dart';
import 'package:echart/chartWidget/chartPathWidget.dart';
import 'package:echart/chartWidget/chartLineWidget.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatefulWidget {
  final ChartModel chartModel;

  //第一条曲线数据
  late List<ChartData>? _firstDataList;

  //第二条曲线数据 最多两条数据
  late List<ChartData>? _secondDataList;

  ChartWidget(Key? key, this.chartModel) : super(key: key) {
    _firstDataList = [];
    _secondDataList = [];
  }

  @override
  ChartWidgetState createState() => ChartWidgetState();
}

class ChartWidgetState extends State<ChartWidget> {
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
    if (widget.chartModel.scrollViewIsRolling) {
      if (pointCount != 0) {
        double currentWidth = widget._firstDataList!.length ~/
            pointCount *
            (widget.chartModel.maxXValue / widget.chartModel.times);
        double chartHalfWidth = (widget.chartModel.width.toDouble() -
                widget.chartModel.lineChartPaddingLeft.toDouble() -
                widget.chartModel.lineChartPaddingRight.toDouble()) *
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
      showBaseline: widget.chartModel.showBaseline,
      firstDataList: widget._firstDataList,
      secondDataList: widget._secondDataList,
      maxYValue: widget.chartModel.maxYValue,
      maxXValue: widget.chartModel.maxXValue,
      times: widget.chartModel.times,
      paddingRight: widget.chartModel.paddingRight,
      paddingLeft: widget.chartModel.paddingLeft,
      paddingTop: widget.chartModel.paddingTop,
      paddingBottom: widget.chartModel.paddingBottom,
      firstPathThresholdOffset: widget.chartModel.firstPathThresholdOffset,
      secondNumberProportion: widget.chartModel.secondNumberProportion,
      firstPathLineWidth: widget.chartModel.firstPathLineWidth,
      secondPathLineWidth: widget.chartModel.secondPathLineWidth,
      firstPathLineColor: widget.chartModel.firstPathLineColor,
      secondPathLineColor: widget.chartModel.secondPathLineColor,
    );
  }

  CustomPainter customPaintLineWidget() {
    return ChartLineWidget(
      specifiesBgColor: widget.chartModel.specifiesBgColor,
      specifiesBgOffset: widget.chartModel.specifiesBgOffset,
      bgColor: widget.chartModel.bgColor,
      xyColor: widget.chartModel.xyColor,
      showYAxis: widget.chartModel.lineChartPaddingLeft <= 0,
      showBaseline: widget.chartModel.showBaseline,
      maxYValue: widget.chartModel.maxYValue,
      ySpace: widget.chartModel.ySpace,
      yIntervalValue: widget.chartModel.yIntervalValue,
      maxXValue: widget.chartModel.maxXValue,
      xSpace: widget.chartModel.xSpace,
      xIntervalValue: widget.chartModel.xIntervalValue,
      paddingLeft:widget.chartModel.paddingLeft,
      paddingRight: widget.chartModel.paddingRight,
      paddingTop: widget.chartModel.paddingTop,
      paddingBottom: widget.chartModel.paddingBottom,
      valueLineSpace: widget.chartModel.valueLineSpace,
      textColor: widget.chartModel.textColor,
      textFontSize: widget.chartModel.textFontSize,
      baselineNormalColor: widget.chartModel.baselineNormalColor,
      baselineValueColor: widget.chartModel.baselineValueColor,
      baselineNormalWidth: widget.chartModel.baselineNormalWidth,
      baselineValueWidth: widget.chartModel.baselineValueWidth,
    );
  }

  CustomPainter customChartFixedYLineWidget(bool isRight) {
    return ChartFixedYLineWidget(
      bgColor: widget.chartModel.fixedYLineBgColor,
      maxYValue: widget.chartModel.maxYValue,
      ySpace: widget.chartModel.ySpace,
      yIntervalValue: isRight ? 20 : widget.chartModel.yIntervalValue,
      paddingLeft: widget.chartModel.paddingLeft,
      paddingRight: widget.chartModel.paddingRight,
      paddingTop: widget.chartModel.paddingTop,
      paddingBottom: widget.chartModel.paddingBottom,
      valueLineSpace: isRight ? 5 : widget.chartModel.valueLineSpace,
      isRightWidget: isRight,
      yAxisMarkValueSuffix: isRight ? "%" : "",
      displayOffset: isRight ? Offset(0, 40) : Offset(0, 0),
      numberProportion: isRight
          ? widget.chartModel.secondNumberProportion
          : widget.chartModel.firstNumberProportion,
      textColor: widget.chartModel.textColor,
      textFontSize: widget.chartModel.textFontSize,
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
                widget.chartModel.scrollViewIsRolling = true;
              });
            } else if (scrollState is ScrollStartNotification) {
              widget.chartModel.scrollViewIsRolling = false;
            }
            return false;
          },
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      widget.chartModel.lineChartPaddingLeft.toDouble(),
                      0,
                      widget.chartModel.getLineChartPaddingRight +
                          widget.chartModel.valueLineSpace.toDouble(),
                      0),
                  width: (widget.chartModel.maxXValue +
                          widget.chartModel.paddingLeft +
                          widget.chartModel.paddingRight)
                      .toDouble(), //宽度+左右padding
                  height: (widget.chartModel.maxYValue +
                          widget.chartModel.paddingTop +
                          widget.chartModel.paddingBottom)
                      .toDouble(), //高度+上下padding
                  child: createLayers(
                      [customPaintLineWidget(), customPaintWidget()]))),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: widget.chartModel.lineChartPaddingLeft.toDouble(),
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
          width: widget.chartModel.getLineChartPaddingRight,
          child: widget.chartModel.hiddenRightYAxis
              ? Container(
                  color: widget.chartModel.fixedYLineBgColor,
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
