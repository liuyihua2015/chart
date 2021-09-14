
import 'dart:ui';

import 'package:echart/ChartData.dart';
import 'package:flutter/material.dart';
import 'package:echart/Pair.dart';

class ChartPathWidget extends CustomPainter {
  //折线图的背景颜色
  Color bgColor;

  //x轴与y轴的颜色
  Color xyColor;

  //path 数据线的颜色
  Color pathLineColor;

  //是否显示x轴与y轴的基准线
  bool showBaseline;

  //第一条曲线数据
  List<ChartData> firstDataList;
  //第二条曲线数据 最多两条数据
  List<ChartData>? secondDataList;

  //表格距离左边的距离
  int paddingLeft;

  //表格距离顶部的距离
  int paddingTop;

  //表格距离底部的距离
  int paddingBottom;

  //绘制x轴、y轴、标记文字的画笔
  Paint? linePaint;

  //绘制线的画笔
  Paint? pathPaint;

  //数值和表之间距离
  int valueLineSpace;

  //y轴数据最大值
  int maxYValue;

  //y轴之间的间隔
  double ySpace;

  //y轴 文本标签 间隔多少显
  double yIntervalValue;

  //x轴数据最大值
  int maxXValue;

  //x轴之间的间隔
  double xSpace;

  //x轴 文本标签 间隔多少显
  double xIntervalValue;

  //该值保证最后一条数据的底部文字能正常显示出来
  int paddingRight = 30;


  late Offset _lastFhrPoint;
  int _lastValue = 0;
  late Path _firstPath;
  late Path _secondPath;

  //画布矩形
  Rect innerRect = Rect.zero;

  ChartPathWidget({
    required this.firstDataList,
    required this.maxYValue,
    required this.maxXValue,
    this.secondDataList,
    this.linePaint,
    this.pathPaint,
    this.bgColor = Colors.white,
    this.xyColor = Colors.black,
    this.pathLineColor = Colors.red,
    this.showBaseline = false,
    this.ySpace = 10,
    this.yIntervalValue = 10,
    this.xSpace = 10,
    this.xIntervalValue = 10,
    this.paddingLeft = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.valueLineSpace = 0,
  }) {
    _lastFhrPoint = Offset(0, 0);
    _lastValue = 0;
    _firstPath = Path();
    _secondPath = Path();

    linePaint = Paint()
      ..color = xyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    pathPaint = Paint()
      ..color = pathLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

  }

  @override
  void paint(Canvas canvas, Size size) {

    //创建一个矩形，方便后续绘制
    innerRect = Rect.fromPoints(
      Offset(paddingLeft.toDouble(), paddingTop.toDouble()),
      Offset(
          size.width - paddingLeft - paddingRight, size.height - paddingBottom),
    );

    drawFirstDataPath(canvas, firstDataList);

    if (secondDataList != null && secondDataList!.length > 0) {
      drawSecondDataPath(canvas, secondDataList!);
    }
  }

   //画第一条曲线
  void drawFirstDataPath(Canvas canvas, List<ChartData> dataList) {
    // 新的最后一个坐标
    Offset newLastPoint = Offset(0, 0);
    double x = 0;
    double y = 0;
    double innerRectStartX = 0;

    for (int i = 0; i < dataList.length; i++) {
      innerRectStartX = innerRect.bottomLeft.dx + (dataList[i].count ~/ 5);

      ChartData data = dataList[i];
      Pair pairData = Pair(
        innerRectStartX,
        //内矩形高度减去数据实际值的实际像素大小，再加上顶部空白的距离
        data.value == 0
            ? 0
            : innerRect.height -
            dataList[i].value / maxYValue * innerRect.height +
            paddingTop,
      );
      double x = pairData.first.toDouble();
      double y = pairData.last.toDouble();
      // print("1--startX:${x},value:${y}");

      if (data.value == 0) {
        _firstPath.moveTo(x, y);
        newLastPoint = Offset(x, y);
      } else {
        if (y == 0) {
          newLastPoint = Offset(0, 0);
        } else {
          if (newLastPoint.dy == 0) {
            _firstPath.moveTo(x, y);
          } else {
            _firstPath.lineTo(x, y);
          }
          newLastPoint = Offset(x, y);
        }
      }
    }

    // //绘画曲线
    canvas.drawPath(_firstPath, pathPaint!);

  }

  //画第二条曲线
  void drawSecondDataPath(Canvas canvas, List<ChartData> dataList) {
    // 新的最后一个坐标
    Offset newLastPoint = Offset(0, 0);
    double x = 0;
    double y = 0;
    double innerRectStartX = 0;

    for (int i = 0; i < dataList.length; i++) {
      innerRectStartX = innerRect.bottomLeft.dx + (dataList[i].count ~/ 5);

      ChartData data = dataList[i];
      Pair pairData = Pair(
        innerRectStartX,
        //内矩形高度减去数据实际值的实际像素大小，再加上顶部空白的距离
        data.value == 0
            ? 0
            : innerRect.height -
            dataList[i].value / maxYValue * innerRect.height +
            paddingTop,
      );
      double x = pairData.first.toDouble();
      double y = pairData.last.toDouble();
      // print("1--startX:${x},value:${y}");

      if (data.value == 0) {
        _secondPath.moveTo(x, y);
        newLastPoint = Offset(x, y);
      } else {
        if (y == 0) {
          newLastPoint = Offset(0, 0);
        } else {
          if (newLastPoint.dy == 0) {
            _secondPath.moveTo(x, y);
          } else {
            _secondPath.lineTo(x, y);
          }
          newLastPoint = Offset(x, y);
        }
      }
    }

    // //绘画曲线
    canvas.drawPath(_secondPath, pathPaint!);

  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}
