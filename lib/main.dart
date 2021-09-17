import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:echart/chartData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'lineChart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<ChartData> fhrDataList = [];
  late List<ChartData> tocoDataList = [];

  GlobalKey<LineChartWidgetState> globalKey = GlobalKey<LineChartWidgetState>();


  @override
  void initState() {
    super.initState();
    addList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  void addList() {
    late List<ChartData> tempfhrDataList = [];
    late List<ChartData> tempTocoDataList = [];

    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    // 定时器，模拟数据返回
    int count = 0;
    const period = const Duration(seconds: 1);
    Timer _timer = Timer.periodic(period, (timer) {
      //到时回调

      double fhr = next(80, 200).toDouble();
      double too = next(0, 101).toDouble();

      for (double i = 0; i < 4; i++) {
        tempfhrDataList.add(ChartData(count.toDouble(), fhr));
        tempTocoDataList.add(ChartData(count.toDouble(), too));
      }

      if (count > 1200) {
        //取消定时器，避免无限回调
        timer.cancel();
      } else {
        globalKey.currentState?.updataDataList(
            tempfhrDataList, tempTocoDataList);
        count++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text("监测数据"),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: 1000, //宽度+左右padding(默认为0)
            height: 260, //高度+上下padding(默认为0)
            child: LineChartWidget(
                globalKey,
                size.width,
                260,
                maxYValue: 200,
                maxXValue: 1000,
                maxSeconds: 1200,

                paddingTop: 30,
                paddingBottom: 30,
                paddingLeft: 0,
                paddingRight: 0,

            ),
          ),
        ),
      ),
    );
  }
}

