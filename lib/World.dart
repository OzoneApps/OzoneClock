import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:ozoneclock/consts.dart';

class World extends StatelessWidget {
  final DateTime curr = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            height: 200,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(200))),
              child: AnalogClock(
                width: 200.0,
                isLive: true,
                hourHandColor: Colors.black,
                minuteHandColor: Colors.black,
                secondHandColor: base,
                showSecondHand: true,
                numberColor: Colors.white,
                showNumbers: true,
                textScaleFactor: 1.4,
                showTicks: false,
                showDigitalClock: false,
                datetime: curr,
              ),
            )),
        SizedBox(
          height: 40,
        ),
        Text(
          "Current Timezone- " + curr.timeZoneName,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 14,
            color: const Color(0x8f1f2426),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              curr.hour.toString() +
                  ":" +
                  (curr.minute.toInt() < 10 ? "0" : "") +
                  curr.minute.toString(),
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 48,
                color: const Color(0xff1f2426),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              (curr.hour.toInt() < 12 ? " AM" : " PM"),
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 24,
                color: const Color(0x8f1f2426),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    )));
  }
}
