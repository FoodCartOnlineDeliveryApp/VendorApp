import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/faq_response.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  Future? faqFuture;

  @override
  void initState() {
    faqFuture = getFaq();
    super.initState();
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
          getTranslated(context, fAQs)!,
          style: TextStyle(
              fontFamily: "ProximaBold",
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
            }),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: FutureBuilder<BaseModel<FaqResponse>>(
          future: faqFuture!.then((value) => value as BaseModel<FaqResponse>),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return DeviceUtils.showProgress(true);
            } else {
              var data = snapshot.data!.data;
              if (data != null) {
                return ListView.builder(
                  itemCount: data.data!.length,
                  itemBuilder: (_, index) {
                    return ExpansionTile(
                        title: Text('${index + 1}.  ${data.data![index].question.toString()}'),
                        children: [
                          ...data.data!.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              child: Text(e.answer.toString()),
                            );
                          }).toList(),
                        ]);
                  },
                );
              } else {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}
