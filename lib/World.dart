import 'dart:async';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:ozoneclock/TimeZones.dart';
import 'package:ozoneclock/consts.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:sortedmap/sortedmap.dart';
import 'package:intl/intl.dart';

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends State<World> {
  DateTime curr = DateTime.now();
  var tzones = new SortedMap(Ordering.byKey());
  var times = [];
  void initState() {
    super.initState();
    curr = DateTime.now();
    Duration updateDuration = Duration(seconds: 1);
    Timer.periodic(updateDuration, update);
    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;
    for (String temp in locations.keys) {
      var loc = tz.getLocation(temp);
      int index = loc.toString().indexOf('/');
      int idx = 0;
      while (index >= 0) {
        idx = index;
        index = loc.toString().indexOf('/', index + 1);
      }
      tzones[loc.toString().substring(idx + 1)] =
          (tz.TZDateTime.from(curr, loc).timeZoneOffset);
    }
  }

  update(Timer timer) {
    // update is only called on live clocks. So, it's safe to update datetime.
    curr = DateTime.now();
    //print(curr);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
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
                  DateFormat('hh:mm:ss').format(curr),
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 48,
                    color: const Color(0xff1f2426),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat(' a').format(curr),
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 24,
                    color: const Color(0x8f1f2426),
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "+ ADD NEW",
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 18,
                  color: const Color(0xff2680eb),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () => {_navigateAndDisplaySelection(context)},
            ),
            SizedBox(
              height: 20,
            ),
            times.length > 0
                ? Expanded(
                    child: ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 100),
                    itemCount: times.length,
                    itemBuilder: (BuildContext context, int index) {
                      var loc = curr.add(tzones[times.elementAt(index)]);
                      return Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: OutlineButton(
                                  padding: EdgeInsets.all(2),
                                  child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            times.elementAt(index).toString(),
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 14,
                                              color: const Color(0xff1f2426),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            DateFormat('EEE d MMM').format(loc),
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 10,
                                              color: const Color(0xff1f2426),
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Text(
                                        DateFormat('h:mm a').format(loc),
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 16,
                                          color: const Color(0xff1f2426),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))));
                    },
                  ))
                : Container()
          ],
        )));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => TimeZones(tzone: tzones)),
    );
    if (result != null && !times.contains(result)) times.add(result);
  }
}
