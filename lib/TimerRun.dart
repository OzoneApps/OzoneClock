import 'package:flutter/material.dart';
import 'dart:math'as math;
import 'package:ozoneclock/consts.dart';
import 'package:ocarina/ocarina.dart';

class TimerRun extends StatefulWidget {
  final duration;
  TimerRun({
    @required this.duration
  });
  @override
  _TimerRunState createState() => _TimerRunState();
}

class _TimerRunState extends State < TimerRun > with TickerProviderStateMixin {
  final player = OcarinaPlayer(
    asset: 'assets/audio/timer.ogg',
    loop: true,
    volume: 0.8,
  );
  AnimationController controller;
  bool completed = false;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    if(duration.inSeconds == 0) {
      player.play();
      completed = true;
    }
    return '${duration.inHours > 0 ? (duration.inHours.toString()+":") : ""}${duration.inMinutes > 0 ? ((duration.inMinutes % 60) .toString()+":") : ""}${(duration.inSeconds % 60).toString()}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    loadPlayer();
    setState(() {
      controller.reverse(
        from: controller.value == 0.0 ?
        1.0 :
        controller.value);
    });
  }

  void loadPlayer() async {
    await player.load();
  }

  @override
  void dispose() {
    player.dispose();
    print("dispose");
    super.dispose();
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
                              painter: TimerPainter(
                                animation: controller,
                                backgroundColor: Colors.white,
                                color: base,
                              ));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: < Widget > [
                            Container(
                              padding: EdgeInsets.only(top: 0.15 * MediaQuery.of(context).size.height, bottom: 0.04 * MediaQuery.of(context).size.height),
                              width: 0.2 * MediaQuery.of(context).size.width,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Label",
                                  hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: kindaGray
                                ),
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: kindaGray
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: controller,
                              builder: (BuildContext context, Widget child) {
                                return Text(
                                  timerString,
                                  style: TextStyle(
                                    fontSize: 50,
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
              padding: EdgeInsets.only(bottom: 40),
              child: Card(
                elevation: 6,
                shape: CircleBorder(),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: completed ? Icon(Icons.stop, color: base, size: 30) : 
                        Icon(controller.isAnimating ?
                          Icons.pause :
                          Icons.play_arrow, color: base, size: 30),
                        onPressed: () {
                          if (controller.isAnimating) {
                            setState(() {
                              controller.stop(canceled: true);
                            });
                          } else if(completed){
                            player.stop();
                            Navigator.pop(context);
                          }
                          else {
                            setState(() {
                              controller.reverse(
                                from: controller.value == 0.0 ?
                                1.0 :
                                controller.value);
                            });
                          }
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

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }): super(repaint: animation);

  final Animation < double > animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = backgroundColor..strokeWidth = 5.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 3.0, paint);
    paint.color = base;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset(size.width / 6.0, size.height / 6.0) & size / 1.5, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
      color != old.color ||
      backgroundColor != old.backgroundColor;
  }
}