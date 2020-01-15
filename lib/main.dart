import 'package:flutter/material.dart';
//import './widgets/simple-bar-chart.dart';
//import './widgets/area_and_line_chart.dart';
import './widgets/spark_chart.dart';
import 'package:graphs/widgets/graficaCurvas.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var data = {
      "Ene": {"label": "Enero", "value": 450000.0},
      "Feb": {"label": "Febrero", "value": 700000.0},
      "Mar": {"label": "Marzo", "value": 100453.0},
      "Abr": {"label": "Abril", "value": 800453.0},
      "May": {"label": "Mayo", "value": 560000.0},
      "Jun": {"label": "Junio", "value": 880000.0}
    };
    var temp = [450000.0,700000.0,280000.0,690453.0,646000.0,880000.0];
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blueGrey,
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: SparkChart(dataGraph: data),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
