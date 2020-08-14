import 'package:shared_preferences/shared_preferences.dart';

String listKey = "listKey";

void storeStringList(String list) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var lst = await prefs.getStringList(listKey);
  print(lst);
  if(lst == null)
    lst = [];
  lst.add(list);
  await prefs.setStringList(listKey, lst);
}

Future<List<dynamic>> getZones() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getStringList(listKey);
}