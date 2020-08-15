import 'package:flutter/material.dart';
import 'package:ozoneclock/consts.dart';
import 'dart:math';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State < Stopwatch > with TickerProviderStateMixin {
  AnimationController controller;
  var displayTime = "00:00:00.00";
  var _stopWatchTimer;
  bool isAnimating = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
    );
    _stopWatchTimer = StopWatchTimer(
      onChange: (value) {
        displayTime = StopWatchTimer.getDisplayTime(value);
        print(displayTime);
      },
    );
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await _stopWatchTimer.dispose();
  }

  void _startAnimation() {
    controller.stop();
    controller.reset();
    controller.repeat(
      period: Duration(seconds: 1),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: < Widget > [
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: < Widget > [
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: SpritePainter(controller));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: < Widget > [
                            SizedBox(
                              height: 0.22 * MediaQuery.of(context).size.height,
                            ),
                            AnimatedBuilder(
                              animation: controller,
                              builder: (BuildContext context, Widget child) {
                                return Text(
                                  displayTime,
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: kindaGray
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 0.1 * MediaQuery.of(context).size.height,
                bottom: 0.2 * MediaQuery.of(context).size.height),
              child: isAnimating ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 6,
                    shape: CircleBorder(),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(isAnimating ?
                              Icons.pause :
                              Icons.play_arrow, color: base, size: 30),
                            onPressed: () {
                              _stopWatchTimer.onExecute
                                .add(StopWatchExecute.stop);
                              controller.stop();
                              setState(() {
                                isAnimating = false;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 0.2 * MediaQuery.of(context).size.width,
                  ),
                  Card(
                    elevation: 6,
                    shape: CircleBorder(),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.stop, color: base, size: 30),
                            onPressed: () {
                              _stopWatchTimer.onExecute
                                .add(StopWatchExecute.reset);
                              controller.reset();
                              setState(() {
                                isAnimating = false;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ) :
              Card(
                elevation: 6,
                shape: CircleBorder(),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon:
                        Icon(Icons.play_arrow, color: base, size: 30),
                        onPressed: () {
                          _stopWatchTimer.onExecute
                            .add(StopWatchExecute.start);
                          _startAnimation();
                          setState(() {
                            isAnimating = true;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;
  SpritePainter(this._animation) : super(repaint: _animation);
  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 0.4);
    Color color = new Color.fromRGBO(38, 128, 235, opacity);
    double size = rect.width / 2;
    double area = size * size;
    double radius = sqrt(area * value / 4);
    final Paint paint = new Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}