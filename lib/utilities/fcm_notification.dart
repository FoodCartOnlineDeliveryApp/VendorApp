import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';

import '../retrofit/api_client.dart';
import '../retrofit/api_header.dart';
import '../retrofit/base_model.dart';
import '../retrofit/server_error.dart';
import 'preference.dart';

class FCMNotification {
  static Future addRemoveFCMToken(BuildContext context, {int processType = 1}) async {
    try {
      DeviceUtils.onLoading(context);
      final userId = SharedPreferenceHelper.getString(
        Preferences.id,
      );
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.deleteToken(); // deleting old token
      final fcmToken = await messaging.getToken(); // creating new token
      int platform;
      if (Platform.isAndroid) {
        platform = 1;
      } else {
        platform = 2;
      }

      Map<String, dynamic> body = {
        "user_id": userId,
        "user_type": "Vendor",
        "user_platform": platform,
        "token": fcmToken,
        "process_type": processType
      };
      print("fcmRequestBody $body");

      final response =
          await ApiClient(ApiHeader().dioData()).addRemoveFCMToken(body);
      print("fcmResponse $response");
      DeviceUtils.hideDialog(context);
    } catch (error, stacktrace) {
      DeviceUtils.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
  }
}
