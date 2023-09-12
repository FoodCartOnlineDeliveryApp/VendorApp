import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/main.dart';
import 'package:mealup_restaurant_side/models/language.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}



class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  int?  value;
  int groupValue = 1;


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
          getTranslated(context, change_password)!,
          style: TextStyle(fontFamily: proxima_nova_bold, color: Palette.loginhead,fontSize: 17),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Colors.black,
            size: 35.0,
          ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),

      body:  GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'))),
            child: ListView.separated(
              itemCount: Language.languageList().length,
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                this.value = 0;
                this.value = Language.languageList()[index].languageCode == SharedPreferenceHelper.getString(Preferences.current_language_code)
                    ? index
                    : null;
                if(SharedPreferenceHelper.getString(Preferences.current_language_code) == 'N/A'){
                  this.value = 0;
                }
                return RadioListTile(
                  value: index,
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: this.value,
                  activeColor: Palette.green,
                  onChanged: (dynamic value) {
                    setState(() async {
                      this.value = value;
                      Locale local = await setLocale(Language.languageList()[index].languageCode);
                      MyApp.setLocale(context, local);
                      SharedPreferenceHelper.setString(Preferences.current_language_code, Language.languageList()[index].languageCode);
                      Navigator.of(context).pop();
                    });
                  },
                  title: Text(Language.languageList()[index].name),
                );
              },
            )),
      ),
    );
  }
}
