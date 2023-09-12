import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmNewPassController = TextEditingController();

  String? oldPassError = '';
  String? newPassError = '';
  String? confirmNewPassError = '';
  bool isProgress = false;
  bool _obscureTextOldPass = true;
  bool _obscureTextNewPass = true;
  bool _obscureTextConfirmNewPass = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          getTranslated(context, change_password)!,
          style: TextStyle(
              fontFamily: proxima_nova_bold,
              color: Palette.loginhead,
              fontSize: 17),
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
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'))),
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Text(
                          getTranslated(context, old_password)!,
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: proxima_nova_bold),
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
                              padding:
                                  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                onEditingComplete: () => node.nextFocus(),
                                controller: oldPassController,
                                obscureText: _obscureTextOldPass,
                                cursorColor: Palette.loginhead,
                                onChanged: (value) {
                                  setState(() {
                                    oldPassError = '';
                                  });
                                },
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureTextOldPass
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Palette.green,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureTextOldPass = !_obscureTextOldPass;
                                        });
                                      },
                                    ),
                                    hintText: getTranslated(
                                        context, password_hint),
                                    alignLabelWithHint: true,
                                    hintStyle: TextStyle(
                                        color: Palette.switchs,
                                        fontSize: 16),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: oldPassError!.isEmpty ? false : true,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            oldPassError!,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: proxima_nova_bold),
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
                          getTranslated(context, new_password)!,
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: proxima_nova_bold),
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
                              BoxShadow(color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                onEditingComplete: () => node.nextFocus(),
                                controller: newPassController,
                                obscureText: _obscureTextNewPass,
                                cursorColor: Palette.loginhead,
                                onChanged: (value) {
                                  setState(() {
                                    newPassError = '';
                                  });
                                },
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureTextNewPass
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Palette.green,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureTextNewPass = !_obscureTextNewPass;
                                        });
                                      },
                                    ),
                                    hintText: getTranslated(
                                        context, password_hint),
                                    alignLabelWithHint: true,
                                    hintStyle: TextStyle(
                                        color: Palette.switchs,
                                        fontSize: 16),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: newPassError!.isEmpty ? false : true,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            newPassError!,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: proxima_nova_bold),
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
                        child: Text(getTranslated(context, confirm_new_password)!,
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: proxima_nova_bold),
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
                              BoxShadow(color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                onEditingComplete: () => node.unfocus(),
                                controller: confirmNewPassController,
                                cursorColor: Palette.loginhead,
                                obscureText: _obscureTextConfirmNewPass,
                                onChanged: (value) {
                                  setState(() {
                                    confirmNewPassError = '';
                                  });
                                },
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureTextConfirmNewPass
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Palette.green,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureTextConfirmNewPass = !_obscureTextConfirmNewPass;
                                        });
                                      },
                                    ),
                                    hintText: getTranslated(
                                        context, confirm_password_hint),
                                    alignLabelWithHint: true,
                                    hintStyle: TextStyle(
                                        color: Palette.switchs,
                                        fontSize: 16),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible:
                            confirmNewPassError!.isEmpty ? false : true,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            confirmNewPassError!,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: proxima_nova_bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isProgress
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                          color: Colors.black12,
                          child: DeviceUtils.showProgress(true)))
                  : Container(),
            ],
          )),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          if (oldPassController.text.isEmpty) {
            setState(() {
              oldPassError = getTranslated(context, empty_error_text);
            });
          } else if (newPassController.text.isEmpty) {
            setState(() {
              newPassError = getTranslated(context, empty_error_text);
            });
          } else if (confirmNewPassController.text.isEmpty) {
            setState(() {
              confirmNewPassError = getTranslated(context, empty_error_text);
            });
          } else {
            Map<String, String> param = new HashMap();
            param['old_password'] = oldPassController.text.toString();
            param['password'] = newPassController.text.toString();
            param['password_confirmation'] =
                confirmNewPassController.text.toString();
            print(param.toString());
            setState(() {
              isProgress = true;
            });
            await changePassword(param).then((value) {
              value.data != null && value.data!.success == true
                  ? Navigator.of(context).pop()
                  : isProgress = false;
            });
            setState(() {});
          }
        },
        child: Container(
          color: Palette.green,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Center(
            child: Text(
              getTranslated(context, change_password)!,
              style: TextStyle(
                  fontSize: 15,
                  color: Palette.white,
                  fontFamily: "ProximaNova"),
            ),
          ),
        ),
      ),
    );
  }
}
