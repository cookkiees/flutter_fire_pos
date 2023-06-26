import 'package:flutter/material.dart';

class ResponsiveMainProvider extends ChangeNotifier {
  int _tabIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int get tabIndex => _tabIndex;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void changeTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }
}
