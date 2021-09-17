import 'dart:ui';
import 'package:echart/chartData.dart';
import 'package:flutter/material.dart';
import 'package:echart/Pair.dart';

class ChartPathWidget extends CustomPainter {
  //first数据线的颜色
  Color firstPathLineColor;

  //second数据线的颜色
  Color secondPathLineColor;

  //first数据线的颜色
  double firstPathLineWidth;

  //second数据线的颜色
  double secondPathLineWidth;

  //第一条线的阈值范围 （min，max）
  Offset firstPathThresholdOffset;

  //第二条线的阈值范围 （min，max）
  Offset secondPathThresholdOffset;

  //是否显示y轴的数值
  bool showBaseline;

  //第一条曲线数据
  List<ChartData>? firstDataList;

  //第二条曲线数据 最多两条数据
  List<ChartData>? secondDataList;

  //表格距离左边的距离
  int paddingLeft;

  //表格距离顶部的距离
  int paddingTop;

  //表格距离底部的距离
  int paddingBottom;

  //表格距离右部的距离
  int paddingRight;

  //绘制线的画笔
  Paint? pathPaint;

  //y轴数据最大值
  int maxYValue;

  //x轴数据最大值
  int maxXValue;

  //x轴时间最大值(秒)
  int maxSeconds;

  //数值的显示比例
  double firstNumberProportion;
  double secondNumberProportion;

  late Offset _lastFirstPoint;
  late Offset _lastSecondPoint;
  double _lastFirstValue = 0;
  double _lastSecondValue = 0;

  late Path _firstPath;
  late Path _secondPath;

  //画布矩形
  Rect innerRect = Rect.zero;

  ChartPathWidget({
    required this.firstDataList,
    required this.maxXValue,
    required this.maxYValue,
    required this.maxSeconds,
    this.firstPathLineColor = Colors.red,
    this.secondPathLineColor = Colors.greenAccent,
    this.firstPathLineWidth = 0.5,
    this.secondPathLineWidth = 0.5,
    this.secondDataList,
    this.pathPaint,
    this.showBaseline = false,
    this.paddingLeft = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.paddingRight = 10,
    this.firstPathThresholdOffset = const Offset(0, 0),
    this.secondPathThresholdOffset = const Offset(0, 0),
    this.firstNumberProportion = 1,
    this.secondNumberProportion = 1,
  }) {
    _lastFirstPoint = Offset(0, 0);
    _lastSecondPoint = Offset(0, 0);
    _lastFirstValue = 0;
    _lastSecondValue = 0;

    _firstPath = Path();
    _secondPath = Path();

    pathPaint = Paint()
      ..color = this.firstPathLineColor
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

    if (firstDataList != null && firstDataList!.length > 0) {
      drawFirstDataPath(canvas, firstDataList!);
    }
    if (secondDataList != null && secondDataList!.length > 0) {
      drawSecondDataPath(canvas, secondDataList!);
    }
  }

  ///画第一条曲线
  void drawFirstDataPath(Canvas canvas, List<ChartData> dataList) {
    // 新的最后一个坐标
    Offset newLastPoint = Offset(0, 0);
    double x = 0;
    double y = 0;
    double innerRectStartX = 0;

    //阈值数值转换  大为小，小为大
    double min =
        getRelativePosition(this.firstPathThresholdOffset.dy.toDouble() * firstNumberProportion);
    double max =
        getRelativePosition(this.firstPathThresholdOffset.dx.toDouble() * firstNumberProportion);

    for (int i = 0; i < dataList.length; i++) {
      innerRectStartX = dataList[i].count * (maxXValue / maxSeconds);
      ChartData data = dataList[i];
      Pair pairData = Pair(
        innerRectStartX,
        getRelativePosition(data.value  * firstNumberProportion),
      );
      double x = pairData.first.toDouble();
      double y = pairData.last.toDouble();
      // print('_firstPath -- y:${y} -- ${min} -- ${max}');

      if (data.value == 0) {
        _firstPath.moveTo(x, y);
        newLastPoint = Offset(x, y);
      } else {
        if (y == 0) {
          newLastPoint = Offset(0, 0);
        } else {
          if (this.firstPathThresholdOffset == Offset(0, 0)) {
            //默认时，不做处理
            if (newLastPoint.dy == 0.0) {
              _firstPath.moveTo(x, y);
            } else {
              _firstPath.lineTo(x, y);
            }
          } else {
            if (_lastFirstValue <= 0 ||
                y <= 0 ||
                y < min ||
                y > max ||
                _lastFirstValue > max ||
                _lastFirstValue < min) {
              _firstPath.moveTo(x, y);
            } else {
              if (y > max ||
                  y < min ||
                  _lastFirstValue > max ||
                  _lastFirstValue < min) {
                _firstPath.moveTo(x, y);
              } else {
                _firstPath.lineTo(x, y);
              }
            }
          }
          newLastPoint = Offset(x, y);
        }
      }

      _lastFirstValue = y;
      if (i == dataList.length-1) {
        _lastFirstPoint = newLastPoint;
        // print(_lastFirstPoint.dx);
      }
    }

    // //绘画曲线
    canvas.drawPath(
        _firstPath,
        pathPaint!
          ..strokeWidth = firstPathLineWidth
          ..color = firstPathLineColor);
  }

  ///画第二条曲线
  void drawSecondDataPath(Canvas canvas, List<ChartData> dataList) {
    // 新的最后一个坐标
    Offset newLastPoint = Offset(0, 0);
    double x = 0;
    double y = 0;
    double innerRectStartX = 0;

    //阈值数值转换  大为小，小为大
    double min =
        getRelativePosition(this.secondPathThresholdOffset.dy.toDouble() * secondNumberProportion);
    double max =
        getRelativePosition(this.secondPathThresholdOffset.dx.toDouble() * secondNumberProportion);

    for (int i = 0; i < dataList.length; i++) {
      innerRectStartX = dataList[i].count * (maxXValue / maxSeconds);
      ChartData data = dataList[i];
      Pair pairData = Pair(
          innerRectStartX,
          //内矩形高度减去数据实际值的实际像素大小，再加上顶部空白的距离
          getRelativePosition(data.value * secondNumberProportion));
      double x = pairData.first.toDouble();
      double y = pairData.last.toDouble();

      // print('_secondPath -- y:${y} -- ${min} -- ${max}');

      if (data.value == 0) {
        _secondPath.moveTo(x, y);
        newLastPoint = Offset(x, y);
      } else {
        if (y == 0) {
          newLastPoint = Offset(0, 0);
        } else {
          if (this.secondPathThresholdOffset == Offset(0, 0)) {
            //默认时，不做处理
            if (newLastPoint.dy == 0.0) {
              _secondPath.moveTo(x, y);
            } else {
              _secondPath.lineTo(x, y);
            }
          } else {
            if (_lastSecondValue <= 0 ||
                y <= 0 ||
                y < min ||
                y > max ||
                _lastSecondValue > max ||
                _lastSecondValue < min) {
              _secondPath.moveTo(x, y);
            } else {
              if (y > max ||
                  y < min ||
                  _lastSecondValue > max ||
                  _lastSecondValue < min) {
                _secondPath.moveTo(x, y);
              } else {
                _secondPath.lineTo(x, y);
              }
            }
          }
          newLastPoint = Offset(x, y);
        }
      }

      _lastSecondValue = y;
      // if (i == dataList.length - 1) {
      //   _lastSecondPoint = newLastPoint;
      // }
    }

    // //绘画曲线
    canvas.drawPath(
        _secondPath,
        pathPaint!
          ..strokeWidth = secondPathLineWidth
          ..color = secondPathLineColor);
  }

  ///获取相对于视图的y值
  double getRelativePosition(double value) {
    //内矩形高度减去数据实际值的实际像素大小，再加上顶部空白的距离
    return value < 0
        ? 0
        : innerRect.height - value / maxYValue * innerRect.height + paddingTop;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
