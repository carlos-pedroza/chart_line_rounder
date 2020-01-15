import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class GraficaCurvas extends StatefulWidget {
  List<double> datos;
  double max;
  double min;
  double height;

  GraficaCurvas(
      {@required this.datos,
      @required this.max,
      @required this.min,
      this.height = 300});

  @override
  _State createState() => _State();
}

class _State extends State<GraficaCurvas> {
  List<double> party;

  @override
  void initState() {
    party = List();
    var factor = widget.max - widget.min;
    for (var dato in widget.datos) {
      var value = (dato - widget.min) / factor;
      party.add(value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: widget.height + 40,
          child: Center(
            child: Text(''),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 2.0),
          child: ClipPath(
            clipper: ClipplingClass(party: party, datos: widget.datos),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.height + 10,
              child: Center(
                child: Text(''),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 0.99],
                  colors: [Colors.indigo[100], Colors.white],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 2.0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, widget.height),
            painter: LinesGraph(party: party),
          ),
        ),
      ],
    );
  }
}

class ClipplingClass extends CustomClipper<Path> {
  List<double> party;
  List<double> datos;

  ClipplingClass({@required this.party, @required this.datos});

  SenoidalGraph senoidalGraph = SenoidalGraph();

  @override
  Path getClip(Size size) {
    var path = Path();
    var partx = size.width / (party.length - 1);

    var he = size.height - 2;
    var xa = 0.0;
    var ya = (he - (party[0] * he));
    path.moveTo(0.0, ya);
    for (var c = 0; c < (party.length - 1); c++) {
      var x = partx * c;
      var y = (he - (party[c] * he)) + 5;

      var xn = partx * c + 1;
      var yn = (he - (party[c + 1] * he)) + 5;

      var valle = (y > ya);

      if (c > 0) {
        var yp = ((c + 1) < party.length) ? party[c + 1] : party[c];
        var yph = (he - (yp * he)) + 5;

        var vA = [x, y];
        var vB = [xa, ya];
        var vC = [xn, yn];

        var cAB = [(vB[0] - vA[0]), (vB[1] - vA[1])];
        var cAC = [(vC[0] - vA[0]), (vC[1] - vA[1])];
        var cBC = [(vC[0] - vB[0]), (vC[1] - vB[1])];

        var mAB = math.sqrt(math.pow(cAB[0], 2) + math.pow(cAB[1], 2));
        var mAC = math.sqrt(math.pow(cAC[0], 2) + math.pow(cAC[1], 2));
        var mBC = math.sqrt(math.pow(cBC[0], 2) + math.pow(cBC[1], 2));

        var escalarAB_AC = (cAB[0] * cAC[0]) + (cAB[1] * cAC[1]);

        var anguloA = math.acos(escalarAB_AC / (mAB * mAC));

        var a = (1 - (anguloA / 128)) / (valle ? 22 : 12);

        var bnd = true;

        if (ya == y && yph == y) {
          bnd = false;
        } else if (ya < y && y < yph) {
          valle = true;
          bnd = false;
        } else if (ya > y && y > yph) {
          valle = true;
          bnd = false;
        }

        var xan = x - 20;

        if (bnd) {
          path.lineTo(xan, y);
          List<Offset> points = senoidalGraph.pointsCurve(
            a,
            xan,
            x,
            y,
            valle,
          );
          senoidalGraph.SetPathPoints(path, points, valle);
        }
        else {
          path.lineTo(x, y);
        }
      } else {
        path.lineTo(x, y);
      }

      xa = x;
      ya = y;
    }

    var yf = (party.length > 0 ? (he - (party[party.length - 1] * he)) + 5 : 0);

    path.lineTo(size.width, yf);
    path.lineTo(size.width, he);
    path.lineTo(0, he);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LinesGraph extends CustomPainter {
  List<double> party;
  SenoidalGraph senoidalGraph = SenoidalGraph();
  LinesGraph({@required this.party});

  @override
  void paint(Canvas canvas, Size size) {
    var partx = size.width / (party.length - 1);
    final Paint paint = new Paint();
    paint.color = Colors.indigo[900];
    paint.strokeWidth = 4;

    final Paint paint2 = new Paint();
    paint2.color = Colors.indigo[900];
    paint2.strokeWidth = 2;

    var he = size.height - 2;
    var xa = 0.0;
    var ya = (he - (party[0] * he));

    for (var c = 0; c < (party.length - 1); c++) {
      var x = partx * c;
      var y = (he - (party[c] * he)) + 5;

      var xn = partx * c + 1;
      var yn = (he - (party[c + 1] * he)) + 5;

      var valle = (y > ya);

      var xan = x - 20;

      if (c < party.length && c > 0) {
        var yp = ((c + 1) < party.length) ? party[c + 1] : party[c];
        var yph = (he - (yp * he)) + 5;

        var vA = [x, y];
        var vB = [xa, ya];
        var vC = [xn, yn];

        var cAB = [(vB[0] - vA[0]), (vB[1] - vA[1])];
        var cAC = [(vC[0] - vA[0]), (vC[1] - vA[1])];
        var cBC = [(vC[0] - vB[0]), (vC[1] - vB[1])];

        var mAB = math.sqrt(math.pow(cAB[0], 2) + math.pow(cAB[1], 2));
        var mAC = math.sqrt(math.pow(cAC[0], 2) + math.pow(cAC[1], 2));
        var mBC = math.sqrt(math.pow(cBC[0], 2) + math.pow(cBC[1], 2));

        var escalarAB_AC = (cAB[0] * cAC[0]) + (cAB[1] * cAC[1]);

        var anguloA = math.acos(escalarAB_AC / (mAB * mAC));

        var a = (1 - (anguloA / 128)) / (valle ? 20 : 10);

        var bnd = true;

        if (ya == y && yph == y) {
          bnd = false;
        } else if (ya < y && y < yph) {
          bnd = false;
          valle = true;
        } else if (ya > y && y > yph) {
          valle = true;
          bnd = false;
        }

        if(bnd) {
        canvas.drawLine(new Offset(xa, ya), new Offset(xan, y), paint);

        List<Offset> points = senoidalGraph.pointsCurve(
          a,
          xan,
          x,
          y,
          valle,
        );
        canvas.drawPoints(PointMode.points, points, paint2);
        }
        else {
          canvas.drawLine(new Offset(xa, ya), new Offset(x, y), paint);
        }
      } else {
        canvas.drawLine(new Offset(xa, ya), new Offset(x, y), paint);
      }

      xa = x;
      ya = y;
    }

    var yf = (party.length > 0 ? (he - (party[party.length - 1] * he)) + 5 : 0);

    canvas.drawLine(new Offset(xa, ya), new Offset(size.width, yf), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SenoidalGraph extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint();
    paint.color = Colors.indigo[900];
    paint.strokeWidth = 5;

    final Paint paint2 = new Paint();
    paint2.color = Colors.greenAccent;
    paint2.strokeWidth = 5;

    List<Offset> points =
        pointsCurve(0.06, 20, size.width - 20, size.height / 2, false);

    canvas.drawPoints(PointMode.points, points, paint);
  }

  List<Offset> pointsCurve(
      double a, double tStart, double tEnd, double lineaBase, bool esValle) {
    List<Offset> points = List<Offset>();
    double fase = 0;
    double f = 1;
    double w = 2 * math.pi * f;

    var up = !esValle;

    if (up == true) {
      tEnd *= 2;
      tStart *= 2;
      for (double t = 1; t >= 0.5; t -= 0.001) {
        double yr = a * math.sin(w * t + fase);

        double y = (lineaBase * yr) + lineaBase;
        double x = ((tEnd - tStart) * t);

        x -= (tEnd / 2);
        x += tStart;
        var offset = Offset(x, y);
        points.add(offset);
      }
    } else {
      tEnd *= 2;
      for (double t = 0; t <= 0.5; t += 0.001) {
        double yr = a * math.sin(w * t + fase);

        double y = (lineaBase * yr) + lineaBase;
        double x = ((tEnd - (tStart * 2)) * t);

        x += tStart;
        var offset = Offset(x, y);
        points.add(offset);
      }
    }

    return points;
  }

  void SetPathPoints(Path path, List<Offset> points, bool valle) {
    if (valle) {
      for (var c = 0; c < points.length; c++) {
        path.lineTo(points[c].dx, points[c].dy);
      }
    } else {
      for (var c = (points.length - 1); c >= 0; c--) {
        path.lineTo(points[c].dx, points[c].dy);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
