import 'package:cafe5_vip_client/screens/app/model.dart';

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
    var lastDate = DateTime.now();
    for (final e in tables) {
      e['f_exclude'] = false;
    }
  }
}