import 'dart:async';
import 'dart:math';

import 'package:echart/model/fhrChartModel.dart';
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
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    // 定时器，模拟数据返回
    int count = 0;
    const period = const Duration(seconds: 1);
    Timer _timer = Timer.periodic(period, (timer) {
      //到时回调

      List<int> tempfhrDataList = [];
      List<int> tempTocoDataList = [];

      int fhr = next(120, 200).toInt();
      int too = next(0, 100).toInt();

      for (double i = 0; i < 4; i++) {
        tempfhrDataList.add(fhr);
        tempTocoDataList.add(too);
      }

      if (count > 1200) {
        //取消定时器，避免无限回调
        timer.cancel();
      } else {
        globalKey.currentState?.addDataList(
            firstList: tempfhrDataList, secondList: tempTocoDataList);
        count++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          tooltip: '重置',
          child: const Icon(Icons.refresh),
          onPressed: () {
            globalKey.currentState?.resetAllDates();

          }),
      appBar: AppBar(
        title: Text("监测中"),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: 1000, //宽度+左右padding(默认为0)
            height: 260, //高度+上下padding(默认为0)
            child: LineChartWidget(globalKey, FhrChartModel(size.width, 260)),
          ),
        ),
      ),
    );
  }
}
