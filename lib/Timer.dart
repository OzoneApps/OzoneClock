import 'package:flutter/material.dart';
import 'package:ozoneclock/TimerRun.dart';
import 'package:ozoneclock/consts.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State < Timer > {
  int hh = 0,
  mm = 0,
  ss = 0;
  String str = "";
  @override
  void initState() {
    super.initState();
    hh = 0;
    mm = 0;
    ss = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: (0.05) * MediaQuery.of(context).size.height,
            ),
            Text(
              (hh < 10 ? "0" : "") +
              hh.toString() +
              ":" +
              (mm < 10 ? "0" : "") +
              mm.toString() +
              ":" +
              (ss < 10 ? "0" : "") +
              ss.toString(),
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 64,
                color: const Color(0xffcccccc),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: (0.02) * MediaQuery.of(context).size.height,
            ),
            Column(
              children: < Widget > [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: < Widget > [
                    numpad('1'),
                    numpad('2'),
                    numpad('3')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: < Widget > [
                    numpad('4'),
                    numpad('5'),
                    numpad('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: < Widget > [
                    numpad('7'),
                    numpad('8'),
                    numpad('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: < Widget > [
                    numpad(''),
                    numpad('0'),
                    Container(
                      height: (0.12) * MediaQuery.of(context).size.height,
                      width: (0.25) * MediaQuery.of(context).size.width,
                      child: FlatButton(
                        child: Text(
                          'DEL',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 24,
                            color: const Color(0xff333333),
                              fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          if (str.length > 0) {
                            manageDisplay("DEL");
                          }
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: (0.02) * MediaQuery.of(context).size.height,
            ),
            str.length > 0 ? Card(
              elevation: 6,
              shape: CircleBorder(),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.play_arrow, color: base, size: 30),
                  onPressed: () => {
                    print("pressed"),
                  },
                ),
              )
            ) : Container()
          ],
        ),
      ));
  }

  Widget numpad(btntext) {
    return Container(
      height: (0.12) * MediaQuery.of(context).size.height,
      width: (0.25) * MediaQuery.of(context).size.width,
      child: FlatButton(
        child: Text(
          btntext,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 48,
            fontWeight: FontWeight.w400
          ),
          textAlign: TextAlign.center
        ),
        onPressed: () {
          if (str.length < 6) {
            manageDisplay(btntext);
          }
        },
      ),
    );
  }
  manageDisplay(String btntext) {
    int len = str.length;
    ss = 0;
    mm = 0;
    hh = 0;
    if (btntext == "DEL") {
      setState(() {
        str = str.substring(0, str.length - 1);
      });
      len = len - 2;
    } else {
      setState(() {
        str = str + btntext;
      });
    }
    if(str.length > 0) {
      setState(() {
        ss = int.parse(str[len]);
        if (str.length > 1)
          ss = ss + 10 * int.parse(str[len - 1]);
        if (str.length > 2)
          mm = int.parse(str[len - 2]);
        if (str.length > 3)
          mm = mm + 10 * int.parse(str[len - 3]);
        if (str.length > 4)
          hh = int.parse(str[len - 4]);
        if (str.length > 5)
          hh = hh + 10 * int.parse(str[len - 5]);
      });
    }
  }
}