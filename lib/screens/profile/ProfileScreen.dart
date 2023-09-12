import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/vendor_detail.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/screens/auth/LoginScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/screens/CashBalanceScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/screens/ChangeLanguageScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/screens/ChangePasswordScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/screens/EarningHistoryScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/screens/FaqScreen.dart';
import 'package:mealup_restaurant_side/screens/profile/screens/ProfileEditScreen.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<BaseModel<VendorDetail>>? vendorDetailFuture;

  @override
  void initState() {
    super.initState();
    vendorDetailFuture = getVendorDetails();
  }

  @override
  Widget build(BuildContext context) {
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
          getTranslated(context, my_restaurant)!,
          style: TextStyle(
              fontFamily: "ProximaBold",
              color: Palette.loginhead,
              fontSize: 18),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'))),
          child: FutureBuilder<BaseModel<VendorDetail>>(
            future: vendorDetailFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return DeviceUtils.showProgress(true);
                } else {
                  DeviceUtils.showProgress(false);
                  var data = snapshot.data!.data!.data!;
                  return SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  data.image!,
                                  fit: BoxFit.fill,
                                  height: 90,
                                  width: 90,
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SharedPreferenceHelper.getString(
                                        Preferences.name),
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontSize: 16,
                                        fontFamily: proxima_nova_bold),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  Text(
                                    data.address!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontSize: 12,
                                        fontFamily: proxima_nova_reg),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading:
                              SvgPicture.asset("assets/images/profileedit.svg"),
                          title: Text(
                            getTranslated(context, edit_profile)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: "ProximaNova",
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileEditScreen(data)));
                            setState(() {});
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading: SvgPicture.asset(
                              "assets/images/profilebalance.svg"),
                          title: Text(
                            getTranslated(context, my_cash_balance)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: "ProximaNova",
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CashBalanceScreen()));
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading: SvgPicture.asset(
                              "assets/images/profileearning.svg"),
                          title: Text(
                            getTranslated(context, earning_history)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: "ProximaNova",
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EarningHistoryScreen()));
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading: SvgPicture.asset(
                              "assets/images/profilelanguage.svg"),
                          title: Text(
                             getTranslated(context, change_app_language)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: "ProximaNova",
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeLanguageScreen()));
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading:
                              SvgPicture.asset("assets/images/profilefaq.svg"),
                          title: Text(
                            getTranslated(context, fAQs)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: "ProximaNova",
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FaqScreen()));
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading: SvgPicture.asset(
                              "assets/images/profileprivacy.svg"),
                          title: Text(
                            getTranslated(context, change_password)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: proxima_nova_reg,
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen()));
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          leading: SvgPicture.asset(
                              "assets/images/profilesignout.svg"),
                          title: Text(
                            getTranslated(context, sign_out)!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: proxima_nova_reg,
                                fontSize: 15),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Palette.loginhead,
                            size: 30,
                          ),
                          onTap: () {
                            SharedPreferenceHelper.clearPref();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false);
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 15,
                        endIndent: 25,
                        color: Palette.profliedivider,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Center(child: Image.asset("assets/images/logo.png",height: 50,width: 200,)),
                      Center(
                          child: Text(
                        "Version 1.0.0",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontFamily: "ProximaNova",
                            fontSize: 11),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  ));
                }
              } else {
                return DeviceUtils.showProgress(true);
              }
            },
          )),
    );
  }
}
