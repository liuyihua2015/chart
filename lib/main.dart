import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:echart/ChartData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LineChart.dart';

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


  @override
  void initState() {

    addList();

    super.initState();
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

      double fhr =  next(120, 161).toDouble();
      double too =  next(0, 101).toDouble();

      for (double i = 0; i < 4; i++) {
        tempfhrDataList.add(ChartData(count.toDouble(), fhr));
        tempTocoDataList.add(ChartData(count.toDouble(), too));
      }
      count++;

      setState((){

        fhrDataList = tempfhrDataList;
        tocoDataList =  tempTocoDataList;

      });
      if (count >= 4800) {
        //取消定时器，避免无限回调
        timer.cancel();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("监测数据"),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: 1060, //宽度+左右padding
              height: 260, //高度+上下padding
              child: LineChart(
                size.width,
                260,
                bgColor: Color(0x00FFFFFF),
                xyColor: Colors.grey,

                paddingTop: 30,
                paddingBottom: 30,

                paddingLeft: 30,
                paddingRight: 30,

                valueLineSpace: 10,

                showBaseline: true,

                specifiesBgOffset: Offset(120, 160),
                specifiesBgColor: Colors.greenAccent,

                maxYValue: 200,
                ySpace: 10,
                yIntervalValue: 40,

                maxXValue: 1000,
                xSpace: 10,
                xIntervalValue: 50,

                firstDataList: fhrDataList,
                secondDataList: tocoDataList,

              ),
            ),
          ),
        ),
      ),
    );
  }
}
