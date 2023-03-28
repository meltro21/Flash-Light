import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LinePainter extends CustomPainter {
  Offset startPosition;
  Offset endPosition;
  LinePainter(this.startPosition, this.endPosition);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4;

    Offset startingPoint = startPosition;
    Offset endingPoint = endPosition;

    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}

class Curve1 extends CustomPainter {
  double curve;
  double height;
  Curve1(this.curve, this.height);
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(100, 100);
    path.quadraticBezierTo(100 + curve, 100, 100, 140);
    path.moveTo(100, 140);
    path.quadraticBezierTo(100 - curve, 140, 100, 180 - height);

    final Paint paint = Paint();
    paint.color = Colors.grey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    paint.strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
    // Add path points here based on your needs
  }

  @override
  bool shouldRepaint(Curve1 oldDelegate) {
    return true;
  }
}

class Curve2 extends CustomPainter {
  double curve;
  double height;
  Curve2(this.curve, this.height);
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(100, 100);
    path.quadraticBezierTo(100 + curve, 100, 100, 140);
    path.moveTo(100, 140);
    path.quadraticBezierTo(100 - curve, 140, 100, 180 - height);

    final Paint paint = Paint();
    paint.color = Colors.grey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    paint.strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
    // Add path points here based on your needs
  }

  @override
  bool shouldRepaint(Curve2 oldDelegate) {
    return true;
  }
}

class CordStretch extends StatefulWidget {
  CordStretch({super.key});

  @override
  State<CordStretch> createState() => _CordStretchState();
}

class _CordStretchState extends State<CordStretch>
    with SingleTickerProviderStateMixin {
  final double x1 = 100.0;
  final double y1 = 100.0;
  final double x2 = 100.0;
  final double y2 = 180.0;
  double start1 = 1.0;
  // double start2 =
  late Offset startPosition;
  late Offset endPosition;
  late AnimationController animationController;
  late Animation animation1;
  late Animation animation2;

  bool show = false;

  bool showMain = true;

  @override
  void initState() {
    startPosition = Offset(x1, y1);
    endPosition = Offset(x2, y2);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation1 = Tween(begin: 1.0, end: 50.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          0.5,
        )))
      ..addListener(() {
        if (animationController.status == AnimationStatus.completed) {}
        setState(() {});
      });
    animation2 = Tween(begin: 1.0, end: 20.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          0.5,
        )))
      ..addListener(() {
        if (animationController.status == AnimationStatus.completed) {}
        setState(() {});
      });

    animationController.addStatusListener((status) {
      if (animationController.status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (animationController.status == AnimationStatus.dismissed) {
        setState(() {
          show = false;
          showMain = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        show == true
            ? CustomPaint(
                painter: Curve1(animation1.value, animation2.value),
                child: SizedBox(),
              )
            : IgnorePointer(),
        show == true
            ? CustomPaint(
                painter: Curve2(animation1.value, animation2.value),
                child: SizedBox(),
              )
            : IgnorePointer(),
        showMain == true
            ? GestureDetector(
                onPanDown: (details) {
                  // setState(() {
                  //   show = false;
                  // });
                  print('clicked');
                },
                onPanUpdate: (details) {
                  print('clicked');
                  setState(() {
                    endPosition = Offset(
                        details.globalPosition.dx, details.globalPosition.dy);
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    show = true;
                    showMain = false;
                    endPosition = Offset(100, 180);
                  });
                  animationController.forward();
                },
                child: CustomPaint(
                  painter: LinePainter(startPosition, endPosition),
                  child: Container(),
                ),
              )
            : IgnorePointer(),

        // ElevatedButton(
        //     onPressed: () {
        //       if (animationController.status == AnimationStatus.completed) {
        //         animationController.reverse();
        //       } else if (animationController.status ==
        //           AnimationStatus.dismissed) {
        //         animationController.forward();
        //       }
        //     },
        //     child: Text('Press me'))
      ],
    ));
  }
}
