import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/menu_and_submenu.dart';
import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/screens/product/AddNewItem.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:sizer/sizer.dart';

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  MenuAndSubmenuData? dropdownValue;
  int? selectedItemId;
  Future? menuFuture;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    menuFuture = getMenuAndSubmenu();
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
        title: Text(
          getTranslated(context, add_new_product)!,
          style: TextStyle(fontFamily: proxima_nova_bold, color: Palette.loginhead, fontSize: 17),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background.png'))),
        child: Column(
          //direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(
                getTranslated(context, food_product_type)!,
                style: TextStyle(
                    color: Palette.loginhead, fontSize: 16, fontFamily: proxima_nova_bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FutureBuilder<BaseModel<MenuAndSubmenu>>(
                      future: menuFuture!.then((value) => value as BaseModel<MenuAndSubmenu>),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return DeviceUtils.showProgress(true);
                        } else {
                          var data = snapshot.data!.data;
                          if (data != null) {
                            return data.data!.length > 0
                                ? DropdownButton<MenuAndSubmenuData>(
                                    //value: dropdownValue,
                                    value: dropdownValue == null
                                        ? dropdownValue
                                        : snapshot.data!.data!.data!
                                            .where((i) => i.name == dropdownValue!.name)
                                            .first,
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Palette.loginhead,
                                    ),
                                    iconSize: 30,
                                    elevation: 16,
                                    isDense: true,
                                    hint: Text(
                                      getTranslated(context, select_food_type)!,
                                      style: TextStyle(fontFamily: proxima_nova_reg),
                                    ),
                                    style: const TextStyle(color: Palette.loginhead),
                                    onChanged: (MenuAndSubmenuData? newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                        selectedItemId = snapshot.data!.data!.data![snapshot.data!.data!.data!.indexOf(newValue!)].id;
                                      });
                                    },
                                    items: snapshot.data!.data!.data!.map((MenuAndSubmenuData? item) {
                                          return new DropdownMenuItem<MenuAndSubmenuData>(
                                            child: Text(item!.name!),
                                            value: item,
                                          );
                                        }).toList(),
                                  )
                                : Container(child: Text('Please add menu'),);
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        height: 45,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        color: Palette.green,
        textColor: Colors.white,
        child: Text(
          getTranslated(context, add_item_for_this_product)!,
          style: TextStyle(fontFamily: proxima_nova_reg, fontSize: 16),
        ),
        onPressed: () {
          if (selectedItemId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddNewItem(dropdownValue, false, null)),
            );
          } else {
            DeviceUtils.toastMessage('Please Select Food Type');
          }
        },
        splashColor: Colors.white30,
      ),
    );
  }
}


