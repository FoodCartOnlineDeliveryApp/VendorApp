import 'package:flutter/material.dart';
import 'package:mealup_restaurant_side/routes/route_names.dart';
import 'package:mealup_restaurant_side/screens/MainScreen.dart';
import 'package:mealup_restaurant_side/screens/auth/LoginScreen.dart';
import 'package:mealup_restaurant_side/screens/auth/RegisterScreen.dart';

class CustomRouter{

  static Route<dynamic> allRoutes(RouteSettings routeSettings) {
    switch(routeSettings.name){
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MainScreen());
    }
    return MaterialPageRoute(builder: (_) => LoginScreen());
  }
}