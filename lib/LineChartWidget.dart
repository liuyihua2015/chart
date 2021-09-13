
import 'dart:ui';

import 'package:echart/ChartData.dart';
import 'package:flutter/material.dart';
import 'package:echart/Pair.dart';

class LineChartWidget extends CustomPainter {
  //折线图的背景颜色
  Color bgColor;

  //x轴与y轴的颜色
  Color xyColor;

  //path 数据线的颜色
  Color pathLineColor;

  //是否显示x轴与y轴的基准线
  bool showBaseline;

  //实际的数据
  List<ChartData> dataList;

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

  //内部折线图的实际宽度
  double realChartRectWidth = 0;

  late Offset _lastFhrPoint;
  int _lastValue = 0;
  late Path _fhrPath;
  late Path _tocoPath;

  //画布矩形
  Rect innerRect = Rect.zero;

  LineChartWidget({
    required this.dataList,
    required this.maxYValue,
    required this.maxXValue,
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
    _fhrPath = Path();
    _tocoPath = Path();

    linePaint = Paint()
      ..color = xyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    pathPaint = Paint()
      ..color = pathLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

    realChartRectWidth = (dataList.length - 1) * xSpace;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //画背景颜色
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);
    //创建一个矩形，方便后续绘制
    innerRect = Rect.fromPoints(
      Offset(paddingLeft.toDouble(), paddingTop.toDouble()),

      //TODO...判断左右空间 和 数值和表的空间
      Offset(size.width - paddingLeft, size.height - paddingBottom),
    );

    //画y轴
    canvas.drawLine(innerRect.topLeft, innerRect.bottomLeft, linePaint!);
    //画另一边y轴
    canvas.drawLine(innerRect.topRight, innerRect.bottomRight, linePaint!);
    //画x轴
    canvas.drawLine(innerRect.bottomLeft, innerRect.bottomRight, linePaint!);

    //画y轴标记
    double startX = innerRect.topLeft.dx - valueLineSpace;
    double startY;

    //需要的标记轴间隔几根
    int markYShaft = yIntervalValue ~/ ySpace;

    for (int i = 0; i < (maxYValue ~/ ySpace) + 1; i++) {
      //需要标记轴的标记值
      int markYShaftValue = i * ySpace.toInt();

      startY = innerRect.topLeft.dy + (i * ySpace);
      if (showBaseline) {
        canvas.drawLine(
          Offset(innerRect.topLeft.dx, startY),
          Offset(innerRect.size.width + paddingRight, startY),
          linePaint!..strokeWidth = (i % markYShaft == 0) ? 1 : 0.3,
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
          linePaint!..strokeWidth = (i % markXShaft == 0) ? 1 : 0.3,
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
    addListPoint(canvas, dataList);
    // //绘画曲线
    canvas.drawPath(_fhrPath, pathPaint!);
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
    print(oldDelegate != this);
    return oldDelegate != this;
  }

//添加所有数据点位
  void addListPoint(Canvas canvas, List<ChartData> fhr) {
    print('曲线路径 addListPoint 重新绘制');
    // 新的最后一个坐标
    Offset newLastPoint = Offset(0, 0);
    double x = 0;
    double y = 0;
    double innerRectStartX = 0;

    for (int i = 0; i < fhr.length; i++) {
      innerRectStartX = innerRect.bottomLeft.dx + (fhr[i].type ~/ 5);

      ChartData data = fhr[i];
      Pair pairData = Pair(
        innerRectStartX,
        //内矩形高度减去数据实际值的实际像素大小，再加上顶部空白的距离
        data.value == 0
            ? 0
            : innerRect.height -
                fhr[i].value / maxYValue * innerRect.height +
                paddingTop,
      );
      double x = pairData.first.toDouble();
      double y = pairData.last.toDouble();
      // print("1--startX:${x},value:${y}");

      if (data.value == 0) {
        _fhrPath.moveTo(x, y);
        newLastPoint = Offset(x, y);
      } else {
        if (y == 0) {
          newLastPoint = Offset(0, 0);
        } else {
          if (newLastPoint.dy == 0) {
            _fhrPath.moveTo(x, y);
          } else {
            _fhrPath.lineTo(x, y);
          }
          newLastPoint = Offset(x, y);
        }
      }
    }

  }
}
