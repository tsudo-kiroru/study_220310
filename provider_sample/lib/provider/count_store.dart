import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Count1Store with ChangeNotifier {
  var count = 0;
  Count1Store({int value = 0}) {
    count = value;
  }
  void increament() {
    count++;
    notifyListeners();
  }
}
class Count2Store with ChangeNotifier {
  var count = 0;
  void increament() {
    count++;
    notifyListeners();
  }
  void update(Count1Store count1Store) {
    count = count1Store.count * 2;
    notifyListeners();
  }
}
class Count3Store with ChangeNotifier {
  var count = 0;
  void increament() {
    count++;
    notifyListeners();
  }
  void update(Count1Store count1Store, Count2Store count2Store) {
    count = count1Store.count + count2Store.count;
    notifyListeners();
  }
}