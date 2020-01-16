# Flutter line chart with rounded interceptions.

This flutter project show the power programing of this incredible tool, it a line chart with rounded interception, it has been developed using trigonometric functions.

## Implement

if you want to use this package, only copy these two dart files to your proyect: 
path:  /lib/widgets

### spark_chart.dart

this class have the main chart functionality. 

###  graficaCurvas.dart

it paint graph detail.

## Include the packages in your project

copy these two class files in to your project, and import to main.dart or another dart page, i include code as sample into main.dart:

```Dart
import 'package:flutter/material.dart';
import './widgets/spark_chart.dart'; //<- INCLUDE PACKAGE
import 'package:graphs/widgets/graficaCurvas.dart'; //<- INCLUDE PACKAGE

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var data = {                //<-- DATA IN A MAP VARIABLE
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
        title: Text(widget.title),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blueGrey,
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: SparkChart(dataGraph: data), //<--- INCLUDE CHART CODE
        ),
      ), 
    );
  }
}
```

## Version 📌

![alt text](https://github.com/carlos-pedroza/chart_line_rounder/blob/master/graph.jpeg)

1.0.0

## Author

* **Carlos Pedroza** - *Develop* - s(carlos.pedrozav@gmail.com)

## License 📄

MIT


---
⌨️ con ❤️ por [carlos_pedroza](https://github.com/carlos-pedroza/chart_line_rounder) 😊
