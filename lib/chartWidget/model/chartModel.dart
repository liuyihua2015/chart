
import 'package:flutter/material.dart';

class ChartModel {
  final double width;
  final double height;

  ///背景颜色
  final Color bgColor;

  ///左右固定Y数值widght背景颜色
  final Color fixedYLineBgColor;

  ///x轴与y轴的颜色
  final Color xyColor;

  ///是否显示x轴与y轴的基准线
  final bool showBaseline;

  ///first数据线的颜色
  final Color firstPathLineColor;

  ///second数据线的颜色
  final Color secondPathLineColor;

  ///first数据线的Width
  final double firstPathLineWidth;

  ///second数据线的Width
  final double secondPathLineWidth;

  ///第一条线的阈值范围 （min，max）
  final Offset firstPathThresholdOffset;

  ///第二条线的阈值范围 （min，max）
  final Offset secondPathThresholdOffset;

  /// LineChart左边距
  final int lineChartPaddingLeft;

  /// LineChart右边距
  final int lineChartPaddingRight;

  ///控件距离左边的距离  当lineChartPaddingLeft>0 时,此参数设置无效
  final int paddingLeft;

  ///控件距离右边的距离  当lineChartPaddingRight>0 时,此参数设置无效
  final int paddingRight;

  ///是否隐藏左边Y轴数据
  final bool hiddenRightYAxis;

  ///控件距离顶部的距离
  final int paddingTop;

  ///控件距离底部的距离
  final int paddingBottom;

  ///数值和表之间距离
  final int valueLineSpace;

  ///y轴最大值
  final int maxYValue;

  ///总时长(秒)
  final int times;

  ///y轴之间的间隔
  final double ySpace;

  ///y轴 文本标签 间隔多少显
  final double yIntervalValue;

  ///x轴最大值
  final int maxXValue;

  ///x轴每列之间的间隔
  final double xSpace;

  ///x轴 文本标签 间隔多少显
  final double xIntervalValue;

  ///指定背景范围
  final Offset specifiesBgOffset;

  ///指定背景颜色
  final Color specifiesBgColor;

  ///xy轴文本颜色
  final Color textColor;
  ///xy轴文本大小
  final double textFontSize;

  ///基线默认颜色
  final Color baselineNormalColor;

  ///xy值对应的基线宽度
  final Color baselineValueColor;

  ///基线默认宽度
  final double baselineNormalWidth;

  ///xy值对应的基线宽度
  final double baselineValueWidth;

  ///数值的显示比例 - 将右边数值转化为左边百分比数组
  final double firstNumberProportion;
  final double secondNumberProportion;

  ///scrollView是否自己滚动
  late bool scrollViewIsRolling;

  ChartModel(
      this.width,
      this.height, {
        this.maxYValue = 200,
        this.maxXValue = 1000,
        this.times = 1200,
        this.bgColor = Colors.transparent,
        this.xyColor = Colors.grey,
        this.showBaseline = true,
        this.ySpace = 10,
        this.yIntervalValue = 40,
        this.xSpace = 10,
        this.xIntervalValue = 50,
        this.paddingLeft = 0,
        this.paddingRight = 0,
        this.paddingTop = 30,
        this.paddingBottom = 30,
        this.valueLineSpace = 10,
        this.specifiesBgOffset = const Offset(120, 160),
        this.firstPathThresholdOffset = const Offset(0, 0),
        this.secondPathThresholdOffset = const Offset(0, 0),
        this.firstPathLineWidth = 1.0,
        this.secondPathLineWidth = 1.0,
        this.firstPathLineColor = Colors.red,
        this.secondPathLineColor = Colors.greenAccent,
        this.specifiesBgColor = Colors.greenAccent,
        this.fixedYLineBgColor = Colors.white,
        this.lineChartPaddingLeft = 40,
        this.lineChartPaddingRight = 40,
        this.hiddenRightYAxis = false,
        this.firstNumberProportion = 1,
        this.secondNumberProportion = 0.4,
        this.textColor = Colors.grey,
        this.textFontSize = 10,
        this.scrollViewIsRolling = true,
        this.baselineNormalColor = Colors.grey,
        this.baselineValueColor = Colors.grey,
        this.baselineNormalWidth = 0.3,
        this.baselineValueWidth = 1,
      });

  // getter
  double get getLineChartPaddingRight {
    return this.hiddenRightYAxis ? this.valueLineSpace.toDouble() : this.lineChartPaddingRight.toDouble();
  }

}


class ChartData {
  double count;//1-1200 点位count
  double value;

  ChartData(this.count, this.value);
}

