import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/screens/insight/InsightScreen.dart';
import 'package:mealup_restaurant_side/screens/orders/HomeScreen.dart';
import 'package:mealup_restaurant_side/screens/product/ProductScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    navigateTo(_currentIndex);
    List<Widget> _fragments = [
      HomeScreen(),
      InsightScreen(),
      ProductScreen(),
      ProfileScreen()
    ];
    return WillPopScope(
      onWillPop: () async => customPop(context),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: _fragments[_currentIndex],
          bottomNavigationBar: BottomAppBar(
            color: Palette.loginhead,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            _currentIndex = 0;
                            navigateTo(_currentIndex);
                          },
                          child: _currentIndex == 0
                              ? bottomIcon(Colors.green,"bag.svg", getTranslated(context, orders)! )
                              : bottomIcon(Colors.white,"bag.svg", getTranslated(context, orders)! )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                            onTap: () {
                              _currentIndex = 1;
                              navigateTo(_currentIndex);
                            },
                            child: _currentIndex == 1
                                ? bottomIcon(Colors.green,"chart.svg",getTranslated(context, insight)!)
                                : bottomIcon(Colors.white,"chart.svg",getTranslated(context, insight)!)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                            onTap: () {
                              _currentIndex = 2;
                              navigateTo(_currentIndex);
                            },
                            child: _currentIndex == 2
                                ? bottomIcon(Colors.green,"leaf.svg",getTranslated(context, product)!)
                                : bottomIcon(Colors.white,"leaf.svg",getTranslated(context, product)!)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                            onTap: () {
                              _currentIndex = 3;
                              navigateTo(_currentIndex);
                            },
                            child: _currentIndex == 3
                                ? bottomIcon(Colors.green,"profile.svg",getTranslated(context, profile)!)
                                : bottomIcon(Colors.white,"profile.svg",getTranslated(context, profile)!)
                        ),
                      ),
                    ),
                  ),
                ]),
          )),
    );
  }

  Column bottomIcon(Color color,String icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/$icon',
          color: color,
          height: 25,
          width: 25,
        ),
        SizedBox(height: 5,),
        Text(
          title, style: TextStyle(color: color, fontSize: 12),
        )
      ],
    );
  }

  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> customPop(BuildContext context) {
    if (_currentIndex == 0) {
      return Future.value(true);
    } else {
      navigateTo(0);
      return Future.value(false);
    }
  }
}


