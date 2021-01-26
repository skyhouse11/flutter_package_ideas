import 'package:flutter/material.dart';
import 'package:trawell/screen/login_screen.dart';

class NavigationService {
  // Constructor
  NavigationService._privateConstructor();

  static final NavigationService _instance =
      NavigationService._privateConstructor();

  static NavigationService get instance => _instance;

  // GlobalKey
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Widget currentScreen = LoginScreen();

  // Main functionality
  @deprecated
  void navigateToRoute(
    String routeName, {
    bool replace = false,
    Map<String, dynamic> args,
  }) async {
    if (replace) {
      await _navigatorKey.currentState.pushReplacementNamed(
        routeName,
        arguments: args ?? <dynamic>{},
      );
    } else {
      await _navigatorKey.currentState.pushNamed(
        routeName,
        arguments: args ?? <dynamic>{},
      );
    }
  }

  void navigateToScreen(
    Widget screen, {
    bool replace = false,
    Map<String, dynamic> args,
  }) async {
    if (screen == currentScreen) {
      return;
    }
    if (replace) {
      await _navigatorKey.currentState.pushReplacement(
        MaterialPageRoute<Object>(
          builder: (context) => screen,
        ),
      );
    } else {
      await _navigatorKey.currentState.push(
        MaterialPageRoute<Object>(
          builder: (context) => screen,
        ),
      );
    }
  }

  void pop({dynamic data}) async {
    _navigatorKey.currentState.pop(data ?? null);
  }
}
