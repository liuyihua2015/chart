import 'dart:ui';

import 'package:echart/ChartData.dart';
import 'package:flutter/material.dart';

class ChartLineWidget extends CustomPainter {
  //折线图的背景颜色
  Color bgColor;

  //x轴与y轴的颜色
  Color xyColor;

  //基线默认颜色
  Color baselineNormalColor;

  //xy值对应的基线宽度
  Color baselineValueColor;

  //基线默认宽度
  double baselineNormalWidth;

  //xy值对应的基线宽度
  double baselineValueWidth;

  //是否显示x轴与y轴的基准线
  bool showBaseline;

  //表格距离左边的距离
  int paddingLeft;

  //表格距离右边的距离
  int paddingRight;

  //表格距离顶部的距离
  int paddingTop;

  //表格距离底部的距离
  int paddingBottom;

  //绘制x轴、y轴、标记文字的画笔
  Paint? linePaint;

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

  //指定背景范围
  Offset specifiesBgOffset;

  //指定背景颜色
  Color specifiesBgColor;

  //画布矩形
  Rect innerRect = Rect.zero;

  ChartLineWidget({
    required this.maxYValue,
    required this.maxXValue,
    this.linePaint,
    this.bgColor = Colors.white,
    this.xyColor = Colors.grey,
    this.baselineNormalColor = Colors.grey,
    this.baselineValueColor = Colors.grey,
    this.baselineNormalWidth = 0.3,
    this.baselineValueWidth = 1,
    this.showBaseline = false,
    this.ySpace = 10,
    this.yIntervalValue = 10,
    this.xSpace = 10,
    this.xIntervalValue = 10,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.valueLineSpace = 0,
    this.specifiesBgOffset = const Offset(0, 0),
    this.specifiesBgColor = Colors.greenAccent,
  }) {

    linePaint = Paint()
      ..color = xyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = baselineNormalWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //画背景颜色
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);

    //画指定背景颜色
    double height = specifiesBgOffset.dy - specifiesBgOffset.dx;
    double top = height + paddingTop;
    print(size.width);
    print(paddingLeft);
    print(paddingRight);
    print(size.width - paddingLeft - paddingRight);
    canvas.drawRect(
        Rect.fromLTWH(paddingLeft.toDouble(), top,
            size.width - paddingLeft - paddingRight, height),
        Paint()..color = specifiesBgColor);

    //创建一个矩形，方便后续绘制
    innerRect = Rect.fromPoints(
      Offset(paddingLeft.toDouble(), paddingTop.toDouble()),
      Offset(
          size.width - paddingLeft - paddingRight, size.height - paddingBottom),
    );

    //画外围xy轴
    drawXYLine(canvas);
    //画所有xy标记线
    drawXYBsseLine(canvas);
  }

  //画外围xy轴
  void drawXYLine(Canvas canvas) {
    //画y轴
    canvas.drawLine(innerRect.topLeft, innerRect.bottomLeft, linePaint!);

    //画另一边y轴
    Offset y_dx =
        Offset(innerRect.topRight.dx + paddingLeft, innerRect.topRight.dy);
    Offset y_dy = Offset(
        innerRect.bottomRight.dx + paddingLeft, innerRect.bottomRight.dy);
    canvas.drawLine(y_dx, y_dy, linePaint!);
    //画x轴
    Offset x_dy = Offset(
        innerRect.bottomRight.dx + paddingLeft, innerRect.bottomRight.dy);
    canvas.drawLine(innerRect.bottomLeft, x_dy, linePaint!);
  }

  //画所有xy标记线
  void drawXYBsseLine(Canvas canvas) {
    //画y轴标记
    double startX = innerRect.topLeft.dx - valueLineSpace;
    double startY = 0;

    //需要的标记轴间隔几根
    int markYShaft = yIntervalValue ~/ ySpace;

    for (int i = 0; i < (maxYValue ~/ ySpace) + 1; i++) {
      //需要标记轴的标记值
      int markYShaftValue = i * ySpace.toInt();

      startY = innerRect.topLeft.dy + (i * ySpace);
      if (showBaseline) {
        canvas.drawLine(
          Offset(innerRect.topLeft.dx, startY),
          Offset(innerRect.bottomRight.dx + paddingLeft, startY),
          linePaint!
            ..strokeWidth =
                (i % markYShaft == 0) ? baselineValueWidth : baselineNormalWidth
            ..color = (i % markYShaft == 0)
                ? baselineValueColor
                : baselineNormalColor,
        );
      } else {
        canvas.drawLine(
          Offset(innerRect.topLeft.dx, startY),
          Offset(innerRect.topLeft.dx, startY),
          linePaint!,
        );
      }
      print('Y轴 重新绘制了');

      if ((i % markYShaft) == 0 && markYShaftValue != 0) {
        drawYText(
          markYShaftValue.toString(),
          Offset(innerRect.topLeft.dx - valueLineSpace,
              innerRect.bottomLeft.dy - i * ySpace),
          canvas,
        );
      }
    }

    //画x轴标记

    //需要的标记轴间隔几根
    int markXShaft = xIntervalValue ~/ xSpace;

    startY = innerRect.bottom;
    for (int i = 0; i < (maxXValue ~/ xSpace) + 1; i++) {
      startX = innerRect.bottomLeft.dx + i * xSpace;
      if (innerRect.bottomLeft.dx < innerRect.left) {
        canvas.save();
        canvas.clipRect(
          Rect.fromLTWH(
            innerRect.left,
            innerRect.top,
            innerRect.width,
            innerRect.height,
          ),
        );
      }

      //需要标记轴的标记值
      int markXShaftValue = i * xSpace ~/ xIntervalValue;

      if (showBaseline) {
        canvas.drawLine(
          Offset(startX, innerRect.top),
          Offset(startX, startY),
          linePaint!
            ..strokeWidth =
                (i % markXShaft == 0) ? baselineValueWidth : baselineNormalWidth
            ..color = (i % markYShaft == 0)
                ? baselineValueColor
                : baselineNormalColor,
        );
      } else {
        canvas.drawLine(
          Offset(startX, innerRect.bottom),
          Offset(startX, startY),
          linePaint!,
        );
      }
      if (innerRect.bottomLeft.dx < innerRect.left) {
        canvas.restore();
      }

      print('X轴 重新绘制了');
      if ((i % markXShaft) == 0 && markXShaftValue != 0) {
        drawYText(
          '${markXShaftValue.toString()} min',
          Offset(innerRect.bottomLeft.dx.toDouble() + i * xSpace + xSpace,
              startY + 5 + valueLineSpace), //5为字体高度
          canvas,
        );
      }
    }
  }

  List getTextPainterAndSize(String text) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      /**/
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.black, fontSize: 10),
      ),
    );
    textPainter.layout();
    Size size = textPainter.size;
    return [textPainter, size];
  }

  void drawYText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text);
    list[0].paint(
        canvas, topLeftOffset.translate(-list[1].width, -list[1].height / 2));
  }

  void drawXText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text);
    list[0].paint(canvas, topLeftOffset.translate(-list[1].width / 2, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // return oldDelegate != this;
    return false;
  }
}
