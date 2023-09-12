import 'dart:collection';
import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/models/add_and_update_customization_item.dart';
import 'package:mealup_restaurant_side/models/product_customization_response.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomizationOptionScreen extends StatefulWidget {
  final CustomizationData customizationData;
  final int? id;

  CustomizationOptionScreen(
      {required this.customizationData, required this.id});


  @override
  _CustomizationOptionScreenState createState() =>
      _CustomizationOptionScreenState();
}

class _CustomizationOptionScreenState extends State<CustomizationOptionScreen> {
  List<Widget> data = [];
  int val = -1;
  bool isChecked = false;

  bool isShowProgress = false;

    var listData;
    List<MClass> controllerClassList = [];
    List<Map<String, dynamic>> updateCustomizationData = [];

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Palette.green;
    }
    return Palette.green;
  }


  update() {
    listData = jsonDecode(widget.customizationData.custimazationItem!);
    if (listData.length != null) {
      for (int i = 0; i < listData.length; i++) {
        controllerClassList.add(MClass(
            TextEditingController(text: listData[i]['name']),
            TextEditingController(text: listData[i]['price']),
            listData[i]['isDefault'] == 1 ? true : false,
            listData[i]['status'] == 1 ? true : false));
        data.add(customizationItem(i));
      }
    }
    if (listData != null) {
      if (listData.length == 0) {
        if (data.isEmpty) {
          data.add(customizationItem(0));
          controllerClassList.add(MClass(
              TextEditingController(), TextEditingController(), false, false));
        }
      }
    } else {
      if (data.isEmpty) {
        data.add(customizationItem(0));
        controllerClassList.add(MClass(
            TextEditingController(), TextEditingController(), false, false));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.customizationData.custimazationItem != null) {
      listData = jsonDecode(widget.customizationData.custimazationItem!);
      if (listData.length != null) {
        for (int i = 0; i < listData.length; i++) {
          controllerClassList.add(MClass(
              TextEditingController(text: listData[i]['name']),
              TextEditingController(text: listData[i]['price']),
              listData[i]['isDefault'] == 1 ? true : false,
              listData[i]['status'] == 1 ? true : false));
          data.add(customizationItem(i));
        }
      }
      if (listData != null) {
        if (listData.length == 0) {
          if (data.isEmpty) {
            data.add(customizationItem(0));
            controllerClassList.add(MClass(TextEditingController(),
                TextEditingController(), false, false));
          }
        }
      } else {
        if (data.isEmpty) {
          data.add(customizationItem(0));
          controllerClassList.add(MClass(
              TextEditingController(), TextEditingController(), false, false));
        }
      }
    }
    else {
      if (data.isEmpty) {
        data.add(customizationItem(0));
        controllerClassList.add(MClass(TextEditingController(), TextEditingController(), false, false));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return ModalProgressHUD(
      inAsyncCall: isShowProgress,
      color: Colors.transparent,
      progressIndicator: SpinKitFadingCircle(color: Palette.green),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Customization Option',
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            Column(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          "Title",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: "ProximaBold"),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Text(
                          "Price",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: "ProximaBold"),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Text(
                          "",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: "ProximaBold"),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child:
                      ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return customizationItem(index);
                          }),
                ),
                InkWell(
                  onTap: () {
                    controllerClassList.add(MClass(TextEditingController(),
                        TextEditingController(), false, false));
                    data.add(customizationItem(data.length + 1));
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Palette.green,
                        ),
                        Text(
                          " Add More",
                          style: TextStyle(
                              color: Palette.green,
                              fontFamily: "ProximaNova",
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < data.length; i++) {
                  Map<String, dynamic> customization = {
                    "name": controllerClassList[i].nameController.text,
                    "price": controllerClassList[i].priceController.text,
                    "isDefault":controllerClassList[i].isDefault == true ? 1 : 0,
                    "status": controllerClassList[i].isChecked == true ? 1 : 0
                  };
                  updateCustomizationData.add(customization);
                }
                String customConvertList = json.encode(updateCustomizationData);

                Map<String, dynamic> param = new HashMap();
                param['menu_id'] = widget.customizationData.menuId;
                param['name'] = widget.customizationData.name;
                param['submenu_id'] = widget.customizationData.submenuId;
                param['type'] = widget.customizationData.type;
                param['min_item_selection'] = widget.customizationData.minItemSelection;
                param['max_item_selection'] = widget.customizationData.maxItemSelection;
                param['custimazation_item'] = customConvertList;

                isShowProgress = true;
                setState(() {});
                addAndUpdateCustomizationItem(widget.customizationData.id, param)
                    .then((value) {
                  if (value.data!.success!) {
                    isShowProgress = false;
                    setState(() {});
                  }
                });

                Navigator.pop(context);
              });
            },
            child: Container(
              color: Palette.green,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Center(
                child: Text(
                  "Add Customization Option",
                  style: TextStyle(
                      fontSize: 15,
                      color: Palette.white,
                      fontFamily: "ProximaNova"),
                ),
              ),
            ),
          )),
    );
  }

  customizationItem(int index) {
    return StatefulBuilder(
      builder: (context, myState) {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Palette.white),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: TextFormField(
                          controller: controllerClassList[index].nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "ex. Souce",
                              hintStyle: TextStyle(
                                  color: Palette.switchs,
                                  fontSize: 15,
                                  fontFamily: "ProximaNova")),
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          validator: (String? value) {
                            if (value!.length == 0) {
                              return "please_enter_custom_name";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Palette.white),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: TextFormField(
                          controller: controllerClassList[index].priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Price",
                              hintStyle: TextStyle(
                                  color: Palette.switchs,
                                  fontSize: 15,
                                  fontFamily: "ProximaNova")),
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          validator: (String? value) {
                            if (value!.length == 0) {
                              return "please_enter_custom_price";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Palette.removeacct),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Palette.white,
                      ),
                      onPressed: () {
                        if (index != 0) {
                          data.removeAt(index);
                        }
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "Default",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 16,
                            fontFamily: "ProximaBold"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Radio<bool>(
                          value: controllerClassList[index].isDefault == true
                              ? true
                              : false,
                          groupValue: true,
                          activeColor: Palette.green,
                          onChanged: (value) {
                            setState(() {
                              for (int i = 0;
                                  i < controllerClassList.length;
                                  i++) {
                                controllerClassList[i].isDefault = false;
                              }
                              controllerClassList[index].isDefault = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 16,
                            fontFamily: "ProximaBold"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: controllerClassList[index].isChecked,
                          onChanged: (bool? value) {
                            myState(() {
                              controllerClassList[index].isChecked = value!;
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            DottedLine(
              direction: Axis.horizontal,
              lineThickness: 1.0,
              dashColor: Palette.green,
            ),
          ],
        );
      },
    );
  }
}

class MClass {
  TextEditingController nameController;

  TextEditingController priceController;

  bool isDefault;

  bool isChecked;

  MClass(this.nameController, this.priceController, this.isDefault,
      this.isChecked);
}


