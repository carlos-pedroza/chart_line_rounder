import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import './graficaCurvas.dart';

class SparkChart extends StatefulWidget {
  final Map<String, Map<String, dynamic>> dataGraph;

  const SparkChart({@required this.dataGraph});

  @override
  _SparkChartState createState() => _SparkChartState();
}

class _SparkChartState extends State<SparkChart> {
  List<double> axisData = List<double>();
  List<String> labelData = List<String>();
  List<bool> selectedData = List<bool>();
  List<String> label2Data = List<String>();
  double eliPoint = 0;
  double skipPoint = 68;

  List<Widget> _createPoints(List data, double maxValue, double minValue,
      double heigth, double width) {
    List<Widget> items = List();
    double _left = 0;
    for (var i = 0; i < data.length; i++) {
      double _value = data[i];
      double _p = (_value - minValue) / (maxValue - minValue);
      _p = 1 - _p;
      double _top = (heigth * _p) + 16;
      var labelTop = _top - 90;
      if (selectedData[i]) {
        items.add(
          Positioned(
            top: (labelTop <= -1) ? _top : labelTop + 60,
            left: _left - 13,
            child: Container(
              color: Color.fromRGBO(11, 18, 29, 1),
              width: 2,
              height: 200,
            ),
          ),
        );
      }
      if (labelTop <= -1) {
        labelTop = _top + 40;
      }

      Widget widget = Positioned(
        top: (_top + 30) <= heigth ? (_top - 18) : (_top - 30),
        left: (_left - 30),
        child: selectedData[i]
            ? Icon(
                Icons.radio_button_checked,
                size: 36,
                color: Color.fromRGBO(11, 18, 29, 1),
              )
            : GestureDetector(
                child: Container(
                  height: 30,
                  width: 30,
                  child: Text(''),
                ),
                onTap: () {
                  if (i > 0 && i < (data.length - 1)) {
                    setState(() {
                      clearSelect();
                      selectedData[i] = true;
                    });
                  }
                },
              ),
      );
      items.add(widget);

      if (selectedData[i] == true) {
        MoneyFormatterOutput totalAmount =
            FlutterMoneyFormatter(amount: axisData[i]).output;
        var labelLeft = (_left - 84);

        if (labelTop <= -1) {
          labelTop = _top + 40;
        }

        if (labelLeft < 0) {
          labelLeft = 2;
        }

        if ((labelLeft + 74) >= width) {
          labelLeft = width - 110;
        }

        Widget labelAmount = Positioned(
          top: labelTop,
          left: labelLeft,
          child: Container(
            width: 150,
            height: 60,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.indigo[50],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Column(
              children: <Widget>[
                Text(
                  'Total ' + label2Data[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromRGBO(11, 18, 29, 1),
                  ),
                ),
                SizedBox(),
                Text(
                  totalAmount.symbolOnLeft,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromRGBO(11, 18, 29, 1),
                  ),
                ),
              ],
            ),
          ),
        );
        items.add(labelAmount);
      }

      _left += (width / (data.length - 1));
    }

    return items;
  }

  Widget labelWrap(item) {
    return Wrap(
      direction: Axis.vertical,
      children: _getWords(item),
    );
  }

  List<Widget> _drawLabel(List labels, double width) {
    List<Widget> items = List<Widget>();
    double padLeft = 80;

    double _left = 45;
    for (var i = 0; i < labels.length; i++) {
      String item = labels[i];
      if (i == (labels.length - 1)) {
        if (selectedData[i]) {
          items.add(Positioned(
            top: 0,
            left: _left - padLeft,
            child: Container(
              color: Color.fromRGBO(11, 18, 29, 1),
              width: 2,
              height: 50,
            ),
          ));
        }
        items.add(
          Positioned(
            top: 0,
            left:
                width - (item.length <= 5 ? item.length * 12 : item.length * 9) - 20,
            child: selectedData[i]
                ? Container(
                    padding: EdgeInsets.only(
                        top: 14, bottom: 10, left: 18, right: 20),
                    width: skipPoint,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                    child: Text(item,
                        style:
                            TextStyle(color: Colors.indigo[400], fontSize: 14)),
                  )
                : GestureDetector(
                    child: Container(
                      width: skipPoint,
                      padding: EdgeInsets.only(
                          top: 14, bottom: 10, left: 18, right: 20),
                      child: Text(item,
                          style: TextStyle(
                              color: Colors.indigo[400], fontSize: 14)),
                    ),
                    onTap: () {
                      if (i > 0 && i < (labels.length - 1)) {
                        setState(() {
                          clearSelect();
                          selectedData[i] = true;
                        });
                      }
                    },
                  ),
          ),
        );
      } else {
        if (selectedData[i]) {
          items.add(Positioned(
            top: 0,
            left: _left - 58,
            child: Container(
              color: Color.fromRGBO(11, 18, 29, 1),
              width: 2,
              height: 50,
            ),
          ));
        }
        items.add(
          Positioned(
            top: 10,
            left: _left == 0 ? 0 : (_left - 90),
            child: selectedData[i]
                ? Container(
                    width: skipPoint,
                    padding: EdgeInsets.only(
                        top: 14, bottom: 10, left: 18, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                    child: Text(
                      item,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ))
                : GestureDetector(
                    child: Container(
                      width: skipPoint,
                      padding: EdgeInsets.only(
                          top: 14, bottom: 10, left: 18, right: 10),
                      child: Text(item,
                          style: TextStyle(
                              color: Colors.indigo[400], fontSize: 14)),
                    ),
                    onTap: () {
                      setState(() {
                        clearSelect();
                        selectedData[i] = true;
                      });
                    },
                  ),
          ),
        );
        _left += (width / (labels.length - 1));
      }
    }

    return items;
  }

  List<Widget> _getWords(String text) {
    List<Widget> res = [];
    var words = text.split(" ");
    for (var word in words) {
      res.add(RotatedBox(quarterTurns: 1, child: Text(word + ' ')));
    }
    return res;
  }

  @override
  void initState() {
    skipPoint -= eliPoint;
    var bnd = true;
    double lastAmount = 0;
    for (var _key in widget.dataGraph.keys) {
      if (bnd) {
        labelData.add('');
        label2Data.add('');
        axisData.add(widget.dataGraph[_key]["value"]);
        selectedData.add(false);
        bnd = false;
      }
      labelData.add(_key);
      label2Data.add(widget.dataGraph[_key]["label"]);
      axisData.add(widget.dataGraph[_key]["value"]);
      selectedData.add(false);
      lastAmount = widget.dataGraph[_key]["value"];
    }
    labelData.add('');
    label2Data.add('');
    axisData.add(lastAmount);
    selectedData.add(false);

    axisData[0] = (axisData[1] > axisData[2])
        ? (axisData[1] - (axisData[1] * 0.10))
        : (axisData[1] + (axisData[1] * 0.10));
    axisData[axisData.length - 1] =
        (axisData[axisData.length - 2] < axisData[axisData.length - 3])
            ? (axisData[axisData.length - 2] +
                (axisData[axisData.length - 2] * 0.10))
            : (axisData[axisData.length - 2] -
                (axisData[axisData.length - 2] * 0.10));
    super.initState();
  }

  void clearSelect() {
    for (var i = 0; i < selectedData.length; i++) {
      selectedData[i] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double _maxValue = 0;
    axisData.forEach((numero) {
      _maxValue = (numero > _maxValue) ? numero : _maxValue;
    });
    double _minValue = _maxValue;
    axisData.forEach((numero) {
      _minValue = (numero < _minValue) ? numero : _minValue;
    });
    double width = MediaQuery.of(context).size.width - 16;
    double height = MediaQuery.of(context).size.height;
    double _graphHeight = 190;
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: <Widget>[
          Container(
            height: (_graphHeight + 12),
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Container(
                  height: _graphHeight,
                  child: GraficaCurvas(
                    datos: axisData,
                    max: _maxValue,
                    min: _minValue,
                    height: _graphHeight,
                  ),
                  /* Sparkline(
                    data: axisData,
                    lineColor: Color.fromRGBO(11, 18, 29, 1),
                    fillMode: FillMode.below,
                    fillGradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.indigo[200], Colors.white70],
                    ),
                    pointsMode: PointsMode.none,
                    lineWidth: 5,
                    sharpCorners: true,
                  ), */
                ),
                ..._createPoints(
                    axisData, _maxValue, _minValue, _graphHeight, width),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 70,
              ),
              ..._drawLabel(labelData, width),
            ],
          )
        ],
      ),
    );
  }
}
