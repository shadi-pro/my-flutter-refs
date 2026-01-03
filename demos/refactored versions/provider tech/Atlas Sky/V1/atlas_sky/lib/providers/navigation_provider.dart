import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _currentRoute = '/';
  final List<String> _navigationHistory = [];

  // Getters
  String get currentRoute => _currentRoute;
  List<String> get navigationHistory => List.unmodifiable(_navigationHistory);

  // Actions
  void navigateTo(String route, {Object? arguments}) {
    _navigationHistory.add(_currentRoute);
    _currentRoute = route;

    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
    notifyListeners();
  }

  void goBack() {
    if (_navigationHistory.isNotEmpty) {
      _currentRoute = _navigationHistory.removeLast();
      navigatorKey.currentState?.pop();
      notifyListeners();
    }
  }

  void replaceCurrent(String route, {Object? arguments}) {
    _currentRoute = route;
    navigatorKey.currentState?.pushReplacementNamed(
      route,
      arguments: arguments,
    );
    notifyListeners();
  }

  void clearHistory() {
    _navigationHistory.clear();
    notifyListeners();
  }
}
