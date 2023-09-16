import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DeviceUtils {

  ///
  /// hides the keyboard if its already open
  ///
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool isValidEmail(String value) {
    /// after @ digit not valid
    final emailRegExp =  RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    // final emailRegExp =  RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

    return emailRegExp.hasMatch(value);
  }

  static Future<bool> checkServiceEnable() async {
    var isEnable = await Geolocator.isLocationServiceEnabled();
    return isEnable;
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static checkForPermission() async {

    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){

      permission = await Geolocator.requestPermission();
      print("denied");
      // Constants.CheckNetwork().whenComplete(() =>    callApiForsetting());


    }else if(permission == LocationPermission.whileInUse){
      print("whileInUse56362");

      // Constants.CheckNetwork().whenComplete(() =>    callApiForsetting());
      //  Constants.currentlatlong().whenComplete(() => Constants.currentlatlong().then((value){print("origin123:$value");}));
      //  Constants.cuttentlocation().whenComplete(() => Constants.cuttentlocation().then((value){}));

    }else if(permission == LocationPermission.always){

      print("always");
      // Constants.CheckNetwork().whenComplete(() =>    callApiForsetting());
      //Constants.currentlatlong().whenComplete(() => Constants.currentlatlong().then((value){print("origin123:$value");}));
      //  Constants.cuttentlocation().whenComplete(() => Constants.cuttentlocation().then((value){}));

    }




  }

  static Widget showProgress(isShowProgress) {
    return ModalProgressHUD(
      inAsyncCall: isShowProgress,
      color: Colors.transparent,
      progressIndicator: SpinKitFadingCircle(color: Palette.green),
      child: Container(),
    );
  }

 static void displayAlert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
            child: ClipRRect(
              borderRadius:
              BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(0),
                color: Palette.green,
                child: Center(
                    child: Text(
                      getTranslated(context, alert)!,
                      style:
                      TextStyle(fontFamily: proxima_nova_bold, color: Palette.white, fontSize: 14),
                    )),
              ),
            ),
          ),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              //height: MediaQuery.of(context).size.height / 2.5,
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          getTranslated(context, coming_soon)!,
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: proxima_nova_bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.green),
              child: Text(
                getTranslated(context, ok)!,
                style: TextStyle(fontFamily: proxima_nova_bold, fontSize: 12, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  static hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
    static onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(width: 20),
                new Text('Please wait...'),
              ],
            ),
          ),
        );
      },
    );
  }

}