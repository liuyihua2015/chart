
import 'dart:ui';
import 'package:flutter/material.dart';

class ChartFixedYLineWidget extends CustomPainter {
  //背景颜色
  Color bgColor;

  //表格距离左边的距离
  int paddingLeft;

  //表格距离右边的距离
  int paddingRight;

  //表格距离顶部的距离
  int paddingTop;

  //表格距离底部的距离
  int paddingBottom;

  //数值和表之间距离
  int valueLineSpace;

  //y轴数据最大值
  int maxYValue;

  //y轴之间的间隔
  double ySpace;

  //y轴 文本标签 间隔多少显
  double yIntervalValue;

  //是否为右边的widget
  bool isRightWidget;

  //值后面添加标记，默认为""
  String yAxisMarkValueSuffix;

  //数值的显示比例
  double numberProportion;

  //数值的显示范围
  Offset displayOffset;

  Color textColor;
  double textFontSize;

  //画布矩形
  Rect innerRect = Rect.zero;

  ChartFixedYLineWidget({
    required this.maxYValue,
    this.bgColor = Colors.white,
    this.ySpace = 10,
    this.yIntervalValue = 10,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.valueLineSpace = 0,
    this.isRightWidget = false,
    this.yAxisMarkValueSuffix = "",
    this.numberProportion = 1,
    this.displayOffset = const Offset(0, 0),
    this.textColor = Colors.black,
    this.textFontSize = 10,
  }) {}

  @override
  void paint(Canvas canvas, Size size) {
    //画背景颜色
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);

    //创建一个矩形，方便后续绘制
    innerRect = Rect.fromPoints(
      Offset(0, 0),
      Offset(size.width, size.height),
    );

    drawYBsseText(canvas, size);
  }

  ///画y轴数据
  void drawYBsseText(Canvas canvas, Size size) {
    //需要的标记轴间隔几根
    int markYShaft = yIntervalValue ~/ ySpace;

    for (int i = 0; i < (maxYValue ~/ ySpace) + 1; i++) {
      //需要标记轴的标记值
      int markYShaftValue = i * ySpace.toInt();

      String value = (markYShaftValue ~/ numberProportion).toString();

      if (yAxisMarkValueSuffix.length > 0) {
        value = value + yAxisMarkValueSuffix;
      }

      if ((i % markYShaft) == 0) {
        if (displayOffset == Offset(0, 0)) {
          drawYText(
            value,
            Offset(
                isRightWidget
                    ? valueLineSpace.toDouble()
                    : size.width - valueLineSpace,
                innerRect.bottomLeft.dy - i * ySpace - paddingTop),
            canvas,
          );
        } else {
          if (markYShaftValue == 0 || (markYShaftValue > displayOffset.dx && markYShaftValue <= displayOffset.dy)) {
            drawYText(
              value,
              Offset(
                  isRightWidget
                      ? valueLineSpace.toDouble()
                      : size.width - valueLineSpace,
                  innerRect.bottomLeft.dy - i * ySpace - paddingTop),
              canvas,
            );
          }
        }
      }
    }
  }

  List getTextPainterAndSize(String text) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      /**/
      text: TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: textFontSize),
      ),
    );
    textPainter.layout();
    Size size = textPainter.size;
    return [textPainter, size];
  }

  void drawYText(String text, Offset topLeftOffset, Canvas canvas) {
    List list = getTextPainterAndSize(text);

    if (isRightWidget) {
      list[0].paint(canvas, topLeftOffset.translate(0, -list[1].height / 2));
    } else {
      list[0].paint(
          canvas, topLeftOffset.translate(-list[1].width, -list[1].height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
