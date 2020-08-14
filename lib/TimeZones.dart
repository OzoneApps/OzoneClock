import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozoneclock/consts.dart';

class TimeZones extends StatefulWidget {
  final tzone;
  TimeZones({@required this.tzone});
  @override
  _TimeZonesState createState() => _TimeZonesState();
}

class _TimeZonesState extends State<TimeZones> {
  var filtered = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "World",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => {Navigator.pop(context, "")},
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                fillColor: base,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                setState(() {
                  filtered = widget.tzone.keys
                      .where((r) => (r
                          .toString()
                          .toLowerCase()
                          .contains(text.toString().toLowerCase())))
                      .toList();
                });
              },
            ),
          ),
          filtered.length == 0
              ? Expanded(
                  child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: widget.tzone.length,
                  itemBuilder: (BuildContext context, int index) {
                    var curr = DateTime.now().toUtc().add(widget.tzone.values.elementAt(index));
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: OutlineButton(
                                onPressed: () => {
                                      Navigator.pop(context,
                                          widget.tzone.keys.elementAt(index))
                                    },
                                padding: EdgeInsets.all(2),
                                child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.tzone.keys
                                            .elementAt(index)
                                            .toString()),
                                        SizedBox(height: 5),
                                        Text(
                                          DateFormat('EEE d MMM').format(curr),
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                    trailing: Text(
                                        DateFormat('h:mm a').format(curr))),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))));
                  },
                ))
              : Expanded(
                  child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: filtered.length,
                  itemBuilder: (BuildContext context, int index) {
                    var curr = DateTime.now().toUtc().add(widget.tzone[filtered.elementAt(index)]);
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: OutlineButton(
                                onPressed: () => {
                                      Navigator.pop(context,
                                          filtered.elementAt(index).toString())
                                    },
                                padding: EdgeInsets.all(2),
                                child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(filtered
                                            .elementAt(index)
                                            .toString()),
                                        SizedBox(height: 5),
                                        Text(
                                          DateFormat('EEE d MMM').format(curr),
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                    trailing: Text(
                                        DateFormat('h:mm a').format(curr))),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))));
                  },
                ))
        ],
      ),
    );
  }
}
