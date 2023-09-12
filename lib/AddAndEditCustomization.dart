import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/create_customization.dart';
import 'package:mealup_restaurant_side/models/delete_customization.dart';
import 'package:mealup_restaurant_side/models/menu_and_submenu.dart';
import 'package:mealup_restaurant_side/models/product_customization_response.dart';
import 'package:mealup_restaurant_side/models/update_customization.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/screens/product/CustomizationOptionScreen.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

class AddAndEditCustomization extends StatefulWidget {
  final Submenu submenu;

  AddAndEditCustomization({Key? key, required this.submenu}) : super(key: key);

  @override
  _AddAndEditCustomizationState createState() =>
      _AddAndEditCustomizationState();
}

class _AddAndEditCustomizationState extends State<AddAndEditCustomization> {
  Future<BaseModel<MenuAndSubmenu>>? menuFuture;
  List<int> minCount = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> maxCount = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int? _maxSelectCount = 0;
  int _minSelectCount = 0;
  String _selectType = "Veg";
  List<String> type = ["Veg", "Non Veg"];

  bool isShowProgress = false;

  @override
  void initState() {
    super.initState();
    menuFuture = getMenuAndSubmenu();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController customName = TextEditingController();
  bool isOn = true;

  Future<void> _refreshProduct() async {
    setState(() {
      menuFuture = getMenuAndSubmenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Customization',
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
        actions: [
          IconButton(
            onPressed: () {
              customName.text = "";
              showDialog(
                  context: context,
                  builder: (context) {
                    return Form(
                      key: formKey,
                      child: StatefulBuilder(builder: (context, myState) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.all(10),
                          title: Text(
                            "Add",
                          ),
                          content: Container(
                            height: 300 ,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text("Customization Name",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                ),
                                Container(
                                  child: TextFormField(
                                    controller: customName,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Enter Customization name",
                                      hintStyle: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    validator: (String? value) {
                                      if (value!.length == 0) {
                                        return "Please enter Customization name";
                                      }
                                      return null;
                                    },
                                    onSaved: (String? name) {},
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Minimum Item Select"),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 60,
                                      child: DropdownButtonFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Palette.blue,
                                        ),
                                        alignment: Alignment.center,
                                        isExpanded: true,
                                        iconSize: 25,
                                        onChanged: (dynamic newValue) {
                                          setState(
                                            () {
                                              _minSelectCount = newValue;
                                            },
                                          );
                                        },
                                        validator: (dynamic value) =>
                                            value == null ? "Select" : null,
                                        items: minCount.map(
                                          (location) {
                                            return DropdownMenuItem<int>(
                                              child: new Text(
                                                location.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Palette.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              value: location,
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Maximum Item Select"),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 60,
                                      child: DropdownButtonFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Palette.blue,
                                        ),
                                        alignment: Alignment.center,
                                        // value: _selectGender,
                                        isExpanded: true,
                                        iconSize: 25,
                                        onChanged: (dynamic newValue) {
                                          setState(
                                            () {
                                              _maxSelectCount = newValue;
                                            },
                                          );
                                        },
                                        validator: (dynamic value) =>
                                            value == null ? "Select" : null,
                                        items: maxCount.map(
                                          (location) {
                                            return DropdownMenuItem<int>(
                                              child: new Text(
                                                location.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Palette.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              value: location,
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Type"),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: DropdownButtonFormField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Palette.blue,
                                        ),
                                        alignment: Alignment.center,
                                        isExpanded: true,
                                        iconSize: 25,
                                        onChanged: (dynamic newValue) {
                                          setState(
                                            () {
                                              _selectType = newValue;
                                            },
                                          );
                                        },
                                        validator: (dynamic value) =>
                                            value == null ? "Select" : null,
                                        items: type.map(
                                          (location) {
                                            return DropdownMenuItem<String>(
                                              child: new Text(
                                                location,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Palette.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              value: location,
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            OutlinedButton(
                              child: Text(
                                "Cancel",
                              ),
                              onPressed: () {
                                myState(
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                            OutlinedButton(
                              child: Text(
                                "Add",
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Map<String, dynamic> param = new HashMap();
                                  param['menu_id'] = widget.submenu.menuId;
                                  param['name'] = customName.text;
                                  param['submenu_id'] = widget.submenu.id;
                                  param['type'] = _selectType;
                                  param['min_item_selection'] =
                                      _minSelectCount;
                                  param['max_item_selection'] =
                                      _maxSelectCount;

                                  isShowProgress = true;
                                  setState(() {});
                                  createCustomization(param).then((value) {
                                    if (value.data!.success!) {
                                      isShowProgress = false;
                                      setState(() {});
                                    }
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        );
                      }),
                    );
                  });
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<BaseModel<ProductCustomizationResponse>>(
          future: getCustomization(widget.submenu.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return snapshot.data!.data!.customizationData!.length > 0
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: snapshot
                                .data!.data!.customizationData!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomizationOptionScreen(
                                                      customizationData: snapshot.data!.data!.customizationData![index],
                                                      id: snapshot.data!.data!.customizationData![index].submenuId,
                                                    )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.06,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.6,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: Container(
                                              alignment: AlignmentDirectional.centerStart,
                                              child: Text(
                                                  "${snapshot.data!.data!.customizationData![index].name}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15))),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Palette.white),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.12,
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Palette.green,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              customName.text = snapshot
                                                  .data!
                                                  .data!
                                                  .customizationData![index]
                                                  .name!;
                                              _selectType = snapshot
                                                  .data!
                                                  .data!
                                                  .customizationData![index]
                                                  .type!;
                                              _minSelectCount = snapshot
                                                  .data!
                                                  .data!
                                                  .customizationData![index]
                                                  .minItemSelection!;
                                              _maxSelectCount = snapshot
                                                  .data!
                                                  .data!
                                                  .customizationData![index]
                                                  .maxItemSelection;
                                              print(
                                                  "Data $_selectType $_minSelectCount");
                                            });
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Form(
                                                    key: formKey,
                                                    child: StatefulBuilder(
                                                        builder: (context,
                                                            myState) {
                                                      return AlertDialog(
                                                        insetPadding:
                                                            EdgeInsets.all(
                                                                10),
                                                        title: Text(
                                                          "update",
                                                        ),
                                                        content: Container(
                                                          height: 220,
                                                          width:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .topStart,
                                                                child: Text(
                                                                    "Name",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15)),
                                                              ),
                                                              Container(
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      customName,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "Enter name",
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            Colors.grey),
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value!
                                                                            .length ==
                                                                        0) {
                                                                      return "Please enter name";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  onSaved:
                                                                      (String?
                                                                          name) {},
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Minimum Item Select"),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    width: 60,
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            Palette.blue,
                                                                      ),
                                                                      alignment:
                                                                          Alignment.center,
                                                                      value:
                                                                          _minSelectCount,
                                                                      isExpanded:
                                                                          true,
                                                                      iconSize:
                                                                          25,
                                                                      onChanged:
                                                                          (dynamic
                                                                              newValue) {
                                                                        setState(
                                                                          () {
                                                                            _minSelectCount = newValue;
                                                                          },
                                                                        );
                                                                      },
                                                                      validator: (dynamic value) => value ==
                                                                              null
                                                                          ? "Select"
                                                                          : null,
                                                                      items: minCount
                                                                          .map(
                                                                        (location) {
                                                                          return DropdownMenuItem<int>(
                                                                            child: new Text(
                                                                              location.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                color: Palette.blue,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            value: location,
                                                                          );
                                                                        },
                                                                      ).toList(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Maximum Item Select"),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    width: 60,
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            Palette.blue,
                                                                      ),
                                                                      alignment:
                                                                          Alignment.center,
                                                                      value:
                                                                          _maxSelectCount,
                                                                      isExpanded:
                                                                          true,
                                                                      iconSize:
                                                                          25,
                                                                      onChanged:
                                                                          (dynamic
                                                                              newValue) {
                                                                        setState(
                                                                          () {
                                                                            _maxSelectCount = newValue;
                                                                          },
                                                                        );
                                                                      },
                                                                      validator: (dynamic value) => value ==
                                                                              null
                                                                          ? "Select"
                                                                          : null,
                                                                      items: maxCount
                                                                          .map(
                                                                        (location) {
                                                                          return DropdownMenuItem<int>(
                                                                            child: new Text(
                                                                              location.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                color: Palette.blue,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            value: location,
                                                                          );
                                                                        },
                                                                      ).toList(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Type"),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    width:
                                                                        100,
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            Palette.blue,
                                                                      ),
                                                                      alignment:
                                                                          Alignment.center,
                                                                      value:
                                                                          _selectType,
                                                                      isExpanded:
                                                                          true,
                                                                      iconSize:
                                                                          25,
                                                                      onChanged:
                                                                          (dynamic
                                                                              newValue) {
                                                                        setState(
                                                                          () {
                                                                            _selectType = newValue;
                                                                          },
                                                                        );
                                                                      },
                                                                      validator: (dynamic value) => value ==
                                                                              null
                                                                          ? "Select"
                                                                          : null,
                                                                      items: type
                                                                          .map(
                                                                        (location) {
                                                                          return DropdownMenuItem<String>(
                                                                            child: new Text(
                                                                              location,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Palette.blue,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            value: location,
                                                                          );
                                                                        },
                                                                      ).toList(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          OutlinedButton(
                                                            child: Text(
                                                              "Cancel",
                                                            ),
                                                            onPressed: () {
                                                              myState(
                                                                () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          OutlinedButton(
                                                            child: Text(
                                                              "Update",
                                                            ),
                                                            onPressed: () {
                                                              if (formKey.currentState!.validate()) {
                                                                Map<String,dynamic>param = new HashMap();
                                                                param['menu_id'] = widget.submenu.menuId;
                                                                param['name'] = customName.text;
                                                                param['submenu_id'] =
                                                                    widget
                                                                        .submenu
                                                                        .id;
                                                                param['type'] = _selectType;
                                                                param['min_item_selection'] = _minSelectCount;
                                                                param['max_item_selection'] = _maxSelectCount;

                                                                isShowProgress =
                                                                    true;
                                                                setState(
                                                                    () {});
                                                                updateCustomization(
                                                                        snapshot
                                                                            .data!
                                                                            .data!
                                                                            .customizationData![index]
                                                                            .id,
                                                                        param)
                                                                    .then((value) {
                                                                  if (value
                                                                      .data!
                                                                      .success!) {
                                                                    isShowProgress =
                                                                        false;
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  );
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Palette.white),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.12,
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete_rounded,
                                            color: Palette.removeacct,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      insetPadding: EdgeInsets.all(10),
                                                      title: Text(
                                                        "Are you want to sure Delete Customization item ?",
                                                        style: TextStyle(
                                                            fontFamily: proxima_nova_reg,
                                                            fontSize: 16),
                                                      ),
                                                      content: Container(
                                                        height: 40,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                          children: [
                                                            TextButton(
                                                              child: Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    color: Palette.green),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    color: Palette.green),
                                                              ),
                                                              onPressed: () async {
                                                                deleteCustomization(snapshot
                                                                    .data!
                                                                    .data!
                                                                    .customizationData![index]
                                                                    .id);
                                                                _refreshProduct();
                                                                Navigator.pop(context);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: Text(
                            getTranslated(context, data_not_available)!));
              } else {
                return DeviceUtils.showProgress(true);
              }
            } else {
              return DeviceUtils.showProgress(true);
            }
          },
        ),
      ),
    );
  }
}
