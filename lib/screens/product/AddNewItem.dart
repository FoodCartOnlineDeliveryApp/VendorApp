import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/menu_and_submenu.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/screens/product/ProductScreen.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddNewItem extends StatefulWidget {
  final MenuAndSubmenuData? data;
  final bool isEdit;
  final Submenu? submenu;

  AddNewItem(this.data, this.isEdit, this.submenu);

  @override
  _AddNewItemState createState() => _AddNewItemState(data, isEdit, submenu);
}

TextEditingController? itemNameController;

TextEditingController? itemPriceController;

TextEditingController? itemDescController;

TextEditingController? itemResetController;

final advancedSwitchController = ValueNotifier<bool>(false);

int isResetDaily = 0;
String? dropdownValue = 'none';
File? foodImage;
bool isProgress = false;

class _AddNewItemState extends State<AddNewItem> {
  final MenuAndSubmenuData? data;
  final bool isEdit;
  final Submenu? submenu;

  _AddNewItemState(MenuAndSubmenuData? data, bool isEdit, submenu)
      : this.data = data,
        this.isEdit = isEdit,
        this.submenu = submenu;

  @override
  void initState()  {
    itemNameController = TextEditingController();
    itemPriceController = TextEditingController();
    itemDescController = TextEditingController();
    itemResetController = TextEditingController();
    advancedSwitchController.value = false;

    // advancedSwitchController = AdvancedSwitchController();
    foodImage = foodImage;
    isProgress = false;
    isEdit
        ? itemNameController!.text = submenu!.name!
        : itemNameController!.text = '';
    isEdit
        ? itemPriceController!.text = submenu!.price!
        : itemPriceController!.text = '';
    isEdit
        ? itemDescController!.text = submenu!.description!
        : itemDescController!.text = '';

    isEdit
        ? itemResetController!.text = submenu!.itemResetValue == null ? '0' :submenu!.itemResetValue.toString()
        : itemResetController = TextEditingController(text: '0');

    isEdit
        ? advancedSwitchController.value = submenu!.status == 1 ? true : false
        : advancedSwitchController.value = false;

    isEdit ? dropdownValue = submenu!.type : dropdownValue = dropdownValue;
    super.initState();
    SharedPreferenceHelper.getInt(Preferences.tab_index);
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
          isEdit ? getTranslated(context, edit_item)! : data!.name!,
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
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: isProgress
            ? DeviceUtils.showProgress(true)
            : SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showPicker(context);
                            },

                            child: Row(
                              children: [
                                Container(
                                    width: 20.w,
                                    height: 20.w,
                                    margin: EdgeInsets.only(left: 10, right: 5),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: foodImage != null
                                            ? Image.file(
                                                foodImage!,
                                                fit: BoxFit.fill,
                                              )
                                            : isEdit
                                                ? Image(
                                                    image: NetworkImage(
                                                        submenu!.image!),
                                                    fit: BoxFit.fill,
                                                  )
                                                : foodImage != null
                                                    ? Image.file(
                                                        foodImage!,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/background.png',
                                                        fit: BoxFit.fill,
                                                      ))),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Palette.green,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(
                                      getTranslated(
                                          context, add_food_item_image)!,
                                      style: TextStyle(
                                          color: Palette.green,
                                          fontSize: 12,
                                          fontFamily: proxima_nova_reg),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getTranslated(context, item_name)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black12, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      child: TextField(
                                        controller: itemNameController,
                                        cursorColor: Palette.loginhead,
                                        decoration: InputDecoration(
                                            hintText: getTranslated(
                                                context, item_name),
                                            hintStyle: TextStyle(
                                                color: Palette.switchs,
                                                fontSize: 16),
                                            border: InputBorder.none),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getTranslated(context, item_price)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black12, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      child: TextField(
                                        controller: itemPriceController,
                                        cursorColor: Palette.loginhead,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: getTranslated(
                                                context, item_price),
                                            hintStyle: TextStyle(
                                                color: Palette.switchs,
                                                fontSize: 16),
                                            border: InputBorder.none),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getTranslated(context, description)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black12, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      child: TextField(
                                        controller: itemDescController,
                                        cursorColor: Palette.loginhead,
                                        decoration: InputDecoration(
                                            hintText: getTranslated(
                                                context, description),
                                            hintStyle: TextStyle(
                                                color: Palette.switchs,
                                                fontSize: 16),
                                            border: InputBorder.none),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
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
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getTranslated(context, type)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                margin: EdgeInsets.only(left: 0, right: 0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black12, width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: DropdownButton(
                                        value: dropdownValue,
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Palette.loginhead,
                                        ),
                                        iconSize: 30,
                                        elevation: 16,
                                        isDense: true,
                                        style: const TextStyle(
                                            color: Palette.loginhead),
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                            print('value $newValue ');
                                          });
                                        },
                                        items: <String>[
                                          'none',
                                          'veg',
                                          'non-veg'
                                        ].map((item) {
                                          return new DropdownMenuItem<String>(
                                            child: Text(item),
                                            value: item,
                                          );
                                        }).toList(),
                                      ),
                                    ),
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
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getTranslated(context, total_item_reset)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black12, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      child: TextField(
                                        enabled:
                                            isResetDaily == 0 ? false : true,
                                        controller: itemResetController,
                                        cursorColor: Palette.loginhead,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: getTranslated(
                                                context, item_reset_value),
                                            focusColor: Colors.red,
                                            hintStyle: TextStyle(
                                                color: Palette.switchs,
                                                fontSize: 16),
                                            border: InputBorder.none),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
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
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getTranslated(context, quantity_reset)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ToggleSwitch(
                                    initialLabelIndex: isResetDaily,
                                    totalSwitches: 2,
                                    activeBgColor: [
                                      Palette.green,
                                    ],
                                    inactiveBgColor: Colors.grey.withAlpha(50),
                                    labels: ['Never', 'Daily'],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                      isResetDaily = index!;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getTranslated(context, status)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AdvancedSwitch(
                                controller: advancedSwitchController,
                                activeColor: Palette.green,
                                inactiveColor: Palette.removeacct,
                                borderRadius:
                                    BorderRadius.all(const Radius.circular(5)),
                                width: 70,
                                activeChild: Text('Yes'),
                                inactiveChild: Text('No'),
                                enabled: true,
                                disabledOpacity: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: GestureDetector(
          onTap: () async {
            Map<String, String?> param = new HashMap();
            if (itemNameController!.text.trim().isEmpty) {
              return DeviceUtils.toastMessage('Item name can\'t blank');
            } else if (itemPriceController!.text.trim().isEmpty) {
              setState(() {
                DeviceUtils.toastMessage('Item price can\'t blank');
              });
            } else {
              String passScreenshotImage;
              if (foodImage != null) {
                try {
                  List<int> imageBytes = foodImage!.readAsBytesSync();
                  String imageB64 = base64Encode(imageBytes);
                  passScreenshotImage = imageB64;
                  param['image'] = passScreenshotImage;
                } catch (e) {
                  DeviceUtils.toastMessage("error is ${e.toString()}");
                }
              }
              isEdit
                  ? param['menu_id'] = submenu!.menuId.toString()
                  : param['menu_id'] = data!.id.toString();
              param['name'] = itemNameController!.text.toString();
              param['price'] = itemPriceController!.text.toString();
              param['description'] = itemDescController!.text.toString();
              param['type'] = dropdownValue;
              param['qty_reset'] = isResetDaily == 0 ? 'never' : 'daily';
              param['status'] =
                  advancedSwitchController.value == true ? '1' : '0';
              param['item_reset_value'] = itemResetController!.text == 'null'
                  ? '0'
                  : itemResetController!.text.toString();
              DeviceUtils.showProgress(true);
              Future<BaseModel<CommonResponse>> s;
              if (isEdit) {
                s = updateSubmenu(submenu!.id, param);
              } else {
                s = addProduct(param);
              }
              setState(() {
                isProgress = true;
              });
              await s.then((value) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProductScreen())));
            }
          },
          child: Container(
            color: Palette.green,
            height: 07.h,
            child: Center(
              child: Text(
                isEdit
                    ? getTranslated(context, update_item)!
                    : getTranslated(context, add_this_item)!,
                style: TextStyle(
                    fontSize: 15,
                    color: Palette.white,
                    fontFamily: proxima_nova_reg),
              ),
            ),
          )),
    );
  }

  pickImageFromCamera(ImageSource source) {
    this.setState(() async {
      ImagePicker imagePicker = ImagePicker();
      await imagePicker.pickImage(source: source).then((value) {
        foodImage = File(value!.path);
      });
    });
  }

  pickImageFromGallery(ImageSource source) {
    this.setState(() async {
      ImagePicker imagePicker = ImagePicker();
      await imagePicker.pickImage(source: source).then((value) {
        foodImage = File(value!.path);
      });
    });
  }

  showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(getTranslated(context, photo_library)!),
                      onTap: () {
                        Navigator.pop(context);
                        pickImageFromCamera(ImageSource.gallery);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(getTranslated(context, camera)!),
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromCamera(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
