import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/utils/global.dart';

class Data {
  final AppModel model;

  Data(this.model);
  //menu
  final List<Map<String, dynamic>> part1 = [];
  final List<Map<String, dynamic>> part2 = [];
  final List<Map<String, dynamic>> dish = [];

  // basket
  final List<Map<String, dynamic>> basket = [];

  // current works
  final List<dynamic> tables = [];
  final List<dynamic> works = [];

  //translation
  final Map<String, Map<String, String>> translation = {};

  void setItemQty(Map<String, dynamic> data) {
    int index = basket.indexWhere((element) => element['f_uuid'] == data['f_uuid']);
    if (index < 0) {
      return;
    }
    basket[index] = data;
  }

  void removeBasketItem(Map<String, dynamic> data) {
    int index = basket.indexWhere((element) => element['f_uuid'] == data['f_uuid']);
    basket.removeAt(index);
    model.basketController.add(basket.length);
  }

  void countWorksStartEnd() {
    List<DateTime> times = List<DateTime>.filled(tables.length, DateTime.now());
    Map<int, int> tablesTimeMap = {};
    for (int i = 0; i < tables.length; i++) {
      tablesTimeMap[tables[i]['f_id']] = i;
    }
    //fill in progress
    for (final e in works) {
      if (e['f_state'] == 1) {
        final i = e['f_items'].first;
        i['f_done'] = strToDateTime(i['f_begin']).add(Duration(minutes: i['f_cookingtime']));
        e['f_done'] = i['f_done'];
        times[tablesTimeMap[e['f_table']]!] = i['f_done'];
      }
    }
    //fill pending
    for (int i = 0; i < works.length; i++) {
      final w = works[i];
      if (w['f_state'] == 1) {
        continue;
      }
      //find nearest box by time
      var box = -1;
      var boxTime = DateTime.now();
      for (var j = 0 ; j < times.length; j++) {
        if (box < 0) {
          box = j;
          boxTime = times[j];
          continue;
        }
        if (boxTime.isAfter(times[j])) {
          box = j;
          boxTime = times[j];
        }
      }
      //assign work to finded box
      final wi = w['f_items'].first;
      w['f_begin'] = boxTime;
      w['f_done'] = boxTime.add(Duration(minutes: wi['f_cookingtime']));
      times[box] = times[box].add(Duration(minutes: wi['f_cookingtime']));
    }
  }
}