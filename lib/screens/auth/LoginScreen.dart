import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/user.dart';
import 'package:mealup_restaurant_side/models/vendor_setting_response.dart';
import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';
import 'package:mealup_restaurant_side/screens/auth/OtpScreen.dart';
import 'package:mealup_restaurant_side/screens/auth/RegisterScreen.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';

import '../MainScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String? emailError = '';
  String? passError = '';
  bool _showProgress = false;

  bool isTokenDone = false;
  bool _obscureText = true;

  @override
  void initState() {
    getVendorSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showProgress,
        opacity: 1.0,
        color: Colors.transparent.withOpacity(0.2),
        progressIndicator: SpinKitFadingCircle(color: Palette.green),
        child: SingleChildScrollView(
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.fill,
                )),
            child: Stack(
              children: [
                Positioned(bottom: 0,left:0,right: 0,child: Image.asset('assets/images/bottom_login.png',fit: BoxFit.cover,)),
                Container(
                  width: width,
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: Image(image: AssetImage(
                          'assets/images/logo.png',
                        ),height: 60,width: width,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, email)!,
                              style: TextStyle(
                                  color: Palette.loginhead, fontSize: 16, fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Palette.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        emailError = '';
                                      });
                                    },
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: emailController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(context, email_hint),
                                        hintStyle: TextStyle(color: Palette.switchs, fontSize: 16),
                                        border: InputBorder.none),
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                            visible: emailError!.isEmpty ? false : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                emailError!,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16, fontFamily: proxima_nova_bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, password)!,
                              style: TextStyle(
                                  color: Palette.loginhead, fontSize: 16, fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Palette.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: passController,
                                    textInputAction: TextInputAction.send,
                                    obscureText: _obscureText,
                                    cursorColor: Palette.loginhead,
                                    onChanged: (value) {
                                      setState(() {
                                        passError = '';
                                      });
                                    },
                                    onEditingComplete: () => node.unfocus(),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Palette.green,
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                        hintText: getTranslated(context, password_hint),
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(color: Palette.switchs, fontSize: 16),
                                        border: InputBorder.none),
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                            visible: passError!.isEmpty ? false : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                passError!,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16, fontFamily: proxima_nova_bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: MaterialButton(
                          height: 45,
                          minWidth: width * 0.8,
                          color: Palette.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                          child: Text(
                            getTranslated(context, button_login)!,
                            style: TextStyle(fontFamily: proxima_nova_reg, fontSize: 16),
                          ),
                          onPressed: () {
                            if (emailController.text.isEmpty) {
                              setState(() {
                                emailError = getTranslated(context, empty_error_text);
                              });
                            } else if (!DeviceUtils.isValidEmail(emailController.text)) {
                              emailError = getTranslated(context, email_valid_error_text);
                              setState(() {});
                            } else if (passController.text.isEmpty) {
                              passError = getTranslated(context, empty_error_text);
                              setState(() {});
                            } else {
                              checkLogin(emailController.text, passController.text);
                            }
                          },
                          splashColor: Colors.white30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: GestureDetector(
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: proxima_nova_reg,
                                    ),
                                    text: getTranslated(context, do_not_have_an_account),
                                    children: [
                                      TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: proxima_nova_bold,
                                          ),
                                          text: getTranslated(context, register))
                                    ])),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<User>> checkLogin(String email, String password) async {
    User response;
    try {
      setState(() {
        _showProgress = true;
      });
      String deviceToken = SharedPreferenceHelper.getString(Preferences.device_token);
      response = await ApiClient(ApiHeader().dioData()).login(email, password, deviceToken);

      if (response.data!.isVerified == 1) {
        saveValueInPref(response);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen(response)),
        );
      }

      setState(() {
        _showProgress = false;
      });
    } catch (error, stacktrace) {
      setState(() {
        _showProgress = false;
      });
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<VendorSettingResponse>> getVendorSetting() async {
    VendorSettingResponse response;
    try {
      response = await ApiClient(ApiHeader().dioData()).vendorSetting();
      response.data!.vendorAppId != null
          ? SharedPreferenceHelper.setString(Preferences.vendor_app_id, response.data!.vendorAppId!)
          : SharedPreferenceHelper.setString(Preferences.vendor_app_id, '');
      SharedPreferenceHelper.setString(Preferences.currency, response.data!.currency!);
      SharedPreferenceHelper.setString(Preferences.currency_symbol, response.data!.currencySymbol!);
      if(response.data!.vendorAppId != null){
        getOneSingleToken(SharedPreferenceHelper.getString(Preferences.vendor_app_id));
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<void> getOneSingleToken(appId) async {
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.setAppId(appId);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();
    await OneSignal.shared.getDeviceState().then(
            (value) {
          if(value != null && value.userId != null){
            SharedPreferenceHelper.setString(Preferences.device_token, value.userId!);
          }else{
            SharedPreferenceHelper.setString(Preferences.device_token, '');
          }
        });
    setState(() {
      isTokenDone = true;
      print('token ======  ${SharedPreferenceHelper.getString(Preferences.device_token)}');
    });
    if (SharedPreferenceHelper.getString(Preferences.device_token) == 'N/A') {
      getOneSingleToken(SharedPreferenceHelper.getString(Preferences.vendor_app_id));
    }
  }

  void saveValueInPref(User response) {
    SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
    if (response.data!.id != null) {
      SharedPreferenceHelper.setString(Preferences.id, response.data!.id.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.id, '');
    }
    if (response.data!.name != null) {
      SharedPreferenceHelper.setString(Preferences.name, response.data!.name.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.name, '');
    }
    if (response.data!.image != null) {
      SharedPreferenceHelper.setString(Preferences.image, response.data!.image!.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.image, '');
    }

    if (response.data!.emailId != null) {
      SharedPreferenceHelper.setString(Preferences.email_id, response.data!.emailId!);
    } else {
      SharedPreferenceHelper.setString(Preferences.email_id, '');
    }
    if (response.data!.emailVerifiedAt != null) {
      SharedPreferenceHelper.setString(
          Preferences.email_verified_at, response.data!.emailVerifiedAt);
    } else {
      SharedPreferenceHelper.setString(Preferences.email_verified_at, '');
    }
    if (response.data!.deviceToken != null) {
      SharedPreferenceHelper.setString(Preferences.device_token, response.data!.deviceToken);
    } else {
      SharedPreferenceHelper.setString(Preferences.device_token, '');
    }
    if (response.data!.phone != null) {
      SharedPreferenceHelper.setString(Preferences.phone, response.data!.phone!);
    } else {
      SharedPreferenceHelper.setString(Preferences.phone, '');
    }
    if (response.data!.phoneCode != null) {
      SharedPreferenceHelper.setString(Preferences.phone_code, response.data!.phoneCode!);
    } else {
      SharedPreferenceHelper.setString(Preferences.phone_code, '');
    }
    if (response.data!.isVerified != null) {
      SharedPreferenceHelper.setString(
          Preferences.is_verified, response.data!.isVerified.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.is_verified, '');
    }
    if (response.data!.otp != null) {
      SharedPreferenceHelper.setString(Preferences.otp, response.data!.otp.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.otp, '');
    }
    if (response.data!.status != null) {
      SharedPreferenceHelper.setString(Preferences.status, response.data!.status.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.status, '');
    }
    if (response.data!.faviroute != null) {
      SharedPreferenceHelper.setString(Preferences.faviroute, response.data!.faviroute.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.faviroute, '');
    }
    if (response.data!.vendorId != null) {
      SharedPreferenceHelper.setString(Preferences.vendor_id, response.data!.vendorId.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.vendor_id, '');
    }
    if (response.data!.language != null) {
      SharedPreferenceHelper.setString(Preferences.language, response.data!.language.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.language, '');
    }
    if (response.data!.ifscCode != null) {
      SharedPreferenceHelper.setString(Preferences.ifsc_code, response.data!.ifscCode.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.ifsc_code, '');
    }
    if (response.data!.accountName != null) {
      SharedPreferenceHelper.setString(
          Preferences.account_name, response.data!.accountName.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.account_name, '');
    }
    if (response.data!.accountNumber != null) {
      SharedPreferenceHelper.setString(
          Preferences.account_number, response.data!.accountNumber.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.account_number, '');
    }

    if (response.data!.micrCode != null) {
      SharedPreferenceHelper.setString(Preferences.micr_code, response.data!.micrCode.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.micr_code, '');
    }
    if (response.data!.token != null) {
      SharedPreferenceHelper.setString(Preferences.token, response.data!.token.toString());
    } else {
      SharedPreferenceHelper.setString(Preferences.token, '');
    }
  }
}
