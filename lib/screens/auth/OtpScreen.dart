import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/user.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import '../MainScreen.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  User? response;

  OtpScreen(User response) {
    this.response = response;
  }

  @override
  _OtpScreenState createState() => _OtpScreenState(response);
}

class _OtpScreenState extends State<OtpScreen> {
  User? response;
  bool isProgress = false;

  _OtpScreenState(User? response) {
    this.response = response;
  }

  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController textEditingController4 = TextEditingController();
  FocusNode _focusNode = new FocusNode();

  int _start = 60;
  late Timer _timer;
  bool isTimerOver =  false;

  int? getOTP;

  @override
  void initState() {
    super.initState();
    startTimer();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });

  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
                isTimerOver = true;
              } else {
                _start = _start - 1;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            getTranslated(context, otp)!,
            style: TextStyle(fontFamily: "ProximaBold", color: Palette.loginhead),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              color: Colors.black,
              size: 35.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  isProgress ? DeviceUtils.showProgress(true) :
          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/background.png'))),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Center(
                      child: Container(
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image.asset(
                            'assets/images/otp.png',
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, enter_otp)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontSize: 16,
                                fontFamily: proxima_nova_bold),
                          ),
                          Text(
                            '00 : $_start',
                            style: TextStyle(
                                color: Palette.switchs, fontSize: 14, fontFamily: proxima_nova_reg),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          OTPTextField(
                            editingController: textEditingController1,
                            textInputAction: TextInputAction.next,
                            focus: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          OTPTextField(
                            editingController: textEditingController2,
                            textInputAction: TextInputAction.next,
                            focus: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          OTPTextField(
                            editingController: textEditingController3,
                            textInputAction: TextInputAction.next,
                            focus: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          OTPTextField(
                            editingController: textEditingController4,
                            textInputAction: TextInputAction.done,
                            focus: (v) {
                              FocusScope.of(context).dispose();
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: GestureDetector(
                        onTap: () async {
                          String one = textEditingController1.text +
                              textEditingController2.text +
                              textEditingController3.text +
                              textEditingController4.text;
                          if (one.length != 4) {
                            DeviceUtils.toastMessage('Enter OTP');
                          } else {
                            Map<String, String> param = new HashMap();
                            param['user_id'] = response!.data!.id.toString();
                            param['otp'] = one;
                            print(param.toString());
                            setState(() {
                              isProgress = true;
                            });
                            await checkOTP(param).then((value) {
                              if (value.data!.success == true) {
                                saveValueInPref(value.data!);
                                Navigator.push(context, new MaterialPageRoute(builder: (context) => MainScreen()));
                              }
                            });
							 isProgress = false;
                            setState(() {});
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), color: Palette.green),
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              'Verify Now',
                              style: TextStyle(
                                  fontFamily: proxima_nova_reg, color: Palette.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Map<String, String> param = new HashMap();
                        param['user_id'] = response!.data!.id.toString();
                        setState(() {
                          isProgress = true;
                        });
                        await resendOTP(param).then((value) {
                        });
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't receive code ?",
                            style: TextStyle(
                                fontFamily: proxima_nova_reg, fontSize: 14, color: Palette.loginhead),
                          ),
                          Text(
                            "Resend Again",
                            style: TextStyle(
                                fontFamily: proxima_nova_bold,
                                fontSize: 14,
                                color: Palette.loginhead),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        "We will share a one OTP code, Don't share this code with any other people,Please check your device.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Palette.switchs, fontFamily: proxima_nova_reg, fontSize: 12),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
  void saveValueInPref(User response ) {
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

// ignore: must_be_immutable
class OTPTextField extends StatelessWidget {
  TextEditingController editingController = TextEditingController();
  TextInputAction textInputAction;
  Function focus;

  OTPTextField(
      {required this.editingController, required this.textInputAction, required this.focus});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: 30,
        height: 80,
        margin: EdgeInsets.all(2.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2.0,
          child: Center(
            child: TextFormField(
              onFieldSubmitted: focus as void Function(String)?,
              controller: editingController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: textInputAction,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (str) {
                if (str.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              style: TextStyle(
                fontFamily: proxima_nova_bold,
                fontSize: 25,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }
}
