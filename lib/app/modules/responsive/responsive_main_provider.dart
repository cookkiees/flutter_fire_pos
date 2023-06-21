import 'package:flutter/widgets.dart';

class ResponsiveMainProvider extends ChangeNotifier {
  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  void changeTabIndex(index) {
    _tabIndex = index;
    notifyListeners();
  }
}
