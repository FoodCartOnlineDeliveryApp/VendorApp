import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/vendor_detail.dart';
import 'package:mealup_restaurant_side/screens/profile/ProfileScreen.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ProfileEditScreen extends StatefulWidget {
  Data? data;

  ProfileEditScreen(Data data) {
    this.data = data;
  }

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState(data);
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController restaurantController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController foodServeController = TextEditingController();
  TextEditingController foodCategoryController = TextEditingController();
  TextEditingController minOrderAmountController = TextEditingController();
  TextEditingController avgDeliveryTimeController = TextEditingController();
  TextEditingController costOfTwoPersonController = TextEditingController();
  TextEditingController businessLicenseNumberController =
      TextEditingController();
  String? timeSlotValue = '';
  String? vendorTypeValue = '';
  String? restaurantError = '';
  String emailError = '';
  String? contactError = '';
  String? addressError = '';
  String? minOrderAmountError = '';
  String? avgDeliveryTimeError = '';
  String costOfTwoPersonError = '';
  String? businessLicenseNumberError = '';

  String? _countryCode;
  String isVendorOwnDriver = "0";

  File? foodImage;
  Data? data;
  bool isProgress = false;

  _ProfileEditScreenState(Data? data) {
    this.data = data;
  }

  @override
  void initState() {
    super.initState();
    foodImage = null;
    isProgress = false;
    restaurantController.text = data!.name!;
    emailController.text = data!.emailId!;
    contactController.text = data!.contact!;
    addressController.text = data!.address!;
    data!.minOrderAmount == null
        ? minOrderAmountController.text = ''
        : minOrderAmountController.text = data!.minOrderAmount!;

    data!.avgDeliveryTime == null
        ? avgDeliveryTimeController.text = ''
        : avgDeliveryTimeController.text = data!.avgDeliveryTime!;

    data!.forTwoPerson == null
        ? costOfTwoPersonController.text = ''
        : costOfTwoPersonController.text = data!.forTwoPerson!;

    data!.licenseNumber == null
        ? businessLicenseNumberController.text = ''
        : businessLicenseNumberController.text = data!.licenseNumber!;

    timeSlotValue = data!.timeSlot;
    if (timeSlotValue == '15' ||
        timeSlotValue == '30' ||
        timeSlotValue == '45') {
      if (!timeSlotValue!.contains('min')) {
        timeSlotValue = '$timeSlotValue mins';
      }
    } else {
      if (timeSlotValue == "60") {
        timeSlotValue = '1 Hour';
      } else if (timeSlotValue == "120") {
        timeSlotValue = '2 Hour';
      } else if (timeSlotValue == "180") {
        timeSlotValue = '3 Hour';
      } else if (timeSlotValue == "240") {
        timeSlotValue = '4 Hour';
      } else if (timeSlotValue == "300") {
        timeSlotValue = '5 Hour';
      }
    }

    vendorTypeValue = data!.vendorType;
    if (vendorTypeValue == 'all') {
      vendorTypeValue = 'All';
    } else if (vendorTypeValue == 'veg') {
      vendorTypeValue = 'Pure Veg';
    } else if (vendorTypeValue == 'non_veg') {
      vendorTypeValue = 'None Veg';
    } else {
      vendorTypeValue = 'Non Applicable';
    }
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
          'Edit Profile',
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
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'))),
          child: Stack(
            children: [
              ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.w,
                              margin: EdgeInsets.only(left: 10, right: 5),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: foodImage != null
                                      ? Image.file(
                                          foodImage!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image(
                                          image: NetworkImage(data!.image!),
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            Container(
                              width: 50.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: Palette.green,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          getTranslated(
                                              context, change_picture)!,
                                          style: TextStyle(
                                              color: Palette.green,
                                              fontSize: 15,
                                              fontFamily: "ProximaNova"),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      showPicker(context);
                                    },
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.remove,
                                        color: Palette.removeacct,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        getTranslated(context, remove_picture)!,
                                        style: TextStyle(
                                            color: Palette.removeacct,
                                            fontSize: 15,
                                            fontFamily: "ProximaNova"),
                                      )
                                    ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, restaurant_name)!,
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
                                    onChanged: (value) {
                                      setState(() {
                                        restaurantError = '';
                                      });
                                    },
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: restaurantController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(
                                            context, restaurant_name_hint),
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
                          Visibility(
                            visible: restaurantError!.isEmpty ? false : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                restaurantError!,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, email)!,
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
                                    enabled: false,
                                    onChanged: (value) {
                                      setState(() {
                                        emailError = '';
                                      });
                                    },
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: emailController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText:
                                            getTranslated(context, email_hint),
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
                            visible: emailError.isEmpty ? false : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                emailError,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, contact_number)!,
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
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
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
                                      width:
                                          MediaQuery.of(context).size.width * 0.30,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: CountryCodePicker(
                                          enabled: false,
                                          padding: EdgeInsets.zero,
                                          initialSelection:
                                              SharedPreferenceHelper.getString(
                                                  Preferences.phone_code),
                                          showDropDownButton: true,
                                          dialogSize: Size.fromRadius(200),
                                          onInit: (country) {
                                            _countryCode = country!.dialCode;
                                          },
                                          onChanged: (countryCode) {
                                            _countryCode = countryCode.toString();
                                            print(_countryCode);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
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
                                      width:
                                          MediaQuery.of(context).size.width * 0.54,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                        child: TextField(
                                          enabled: false,
                                          onEditingComplete: () => node.nextFocus(),
                                          controller: contactController,
                                          onChanged: (value) {
                                            setState(() {
                                              contactError = '';
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintText: "000 000 0000",
                                              hintStyle: TextStyle(
                                                  color: Palette.switchs,
                                                  fontSize: 14),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 14),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                            visible: contactError!.isEmpty ? false : true,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                contactError!,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, address)!,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 5, 20, 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        addressError = '';
                                      });
                                    },
                                    onEditingComplete: () =>
                                        node.nextFocus(),
                                    controller: addressController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(
                                            context, address_hint),
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
                          Visibility(
                            visible:
                                restaurantError!.isEmpty ? false : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                restaurantError!,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, minimum_order_amount)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 5, 20, 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        minOrderAmountError = '';
                                      });
                                    },
                                    onEditingComplete: () =>
                                        node.nextFocus(),
                                    controller: minOrderAmountController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(
                                            context, minimum_order_amount)!,
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
                          Visibility(
                            visible: minOrderAmountError!.isEmpty
                                ? false
                                : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                minOrderAmountError!,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, avg_delivery_time)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 5, 20, 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        avgDeliveryTimeError = '';
                                      });
                                    },
                                    onEditingComplete: () =>
                                        node.nextFocus(),
                                    controller: avgDeliveryTimeController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(
                                            context, avg_delivery_time)!,
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
                          Visibility(
                            visible: avgDeliveryTimeError!.isEmpty
                                ? false
                                : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                avgDeliveryTimeError!,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, cost_of_two_person)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 5, 20, 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        costOfTwoPersonError = '';
                                      });
                                    },
                                    onEditingComplete: () =>
                                        node.nextFocus(),
                                    controller: costOfTwoPersonController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(
                                            context, cost_of_two_person)!,
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
                          Visibility(
                            visible: costOfTwoPersonError.isEmpty
                                ? false
                                : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                costOfTwoPersonError,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, business_license_number)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 5, 20, 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        businessLicenseNumberError = '';
                                      });
                                    },
                                    onEditingComplete: () =>
                                        node.nextFocus(),
                                    controller:
                                        businessLicenseNumberController,
                                    cursorColor: Palette.loginhead,
                                    decoration: InputDecoration(
                                        hintText: getTranslated(context,
                                            business_license_number)!,
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
                          Visibility(
                            visible: businessLicenseNumberError!.isEmpty
                                ? false
                                : true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                businessLicenseNumberError!,
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
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, time_slots)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 15, 20, 15),
                                  child: Center(
                                    child: DropdownButton(
                                        value: timeSlotValue,
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Palette.loginhead,
                                          size: 20,
                                        ),
                                        iconSize: 30,
                                        elevation: 16,
                                        isDense: true,
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: proxima_nova_reg,
                                            fontSize: 16),
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            timeSlotValue = newValue;
                                          });
                                        },
                                        items: <String>[
                                          '15 mins',
                                          '30 mins',
                                          '45 mins',
                                          '1 Hour',
                                          '2 Hour',
                                          '3 Hour',
                                          '4 Hour',
                                          '5 Hour',
                                        ].map((item) {
                                          return new DropdownMenuItem<
                                              String>(
                                            child: Text(item),
                                            value: item,
                                          );
                                        }).toList()),
                                  ),
                                ),
                              ),
                            ),
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
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              getTranslated(context, vendor_type)!,
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 15, 20, 15),
                                  child: Center(
                                    child: DropdownButton(
                                        value: vendorTypeValue,
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Palette.loginhead,
                                          size: 20,
                                        ),
                                        iconSize: 30,
                                        elevation: 16,
                                        isDense: true,
                                        style: TextStyle(
                                            color: Palette.loginhead,
                                            fontFamily: proxima_nova_reg,
                                            fontSize: 16),
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            vendorTypeValue = newValue;
                                          });
                                        },
                                        items: <String>[
                                          'All',
                                          'Pure Veg',
                                          'None Veg',
                                          'Non Applicable',
                                        ].map((item) {
                                          return new DropdownMenuItem<
                                              String>(
                                            child: Text(item),
                                            value: item,
                                          );
                                        }).toList()),
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
          if (restaurantController.text.isEmpty) {
            setState(() {
              restaurantError = getTranslated(context, empty_error_text);
            });
          } else if (contactController.text.isEmpty) {
            setState(() {
              contactError = getTranslated(context, empty_error_text);
            });
          } else if (addressController.text.isEmpty) {
            setState(() {
              addressError = getTranslated(context, empty_error_text);
            });
          } else if (minOrderAmountController.text.isEmpty) {
            setState(() {
              minOrderAmountError = getTranslated(context, empty_error_text);
            });
          } else if (costOfTwoPersonController.text.isEmpty) {
            setState(() {
              minOrderAmountError = getTranslated(context, empty_error_text);
            });
          } else if (avgDeliveryTimeController.text.isEmpty) {
            setState(() {
              avgDeliveryTimeError = getTranslated(context, empty_error_text);
            });
          } else if (businessLicenseNumberController.text.isEmpty) {
            setState(() {
              businessLicenseNumberError =
                  getTranslated(context, empty_error_text);
            });
          } else {
            Map<String, String> param = new HashMap();
            if (foodImage != null) {
              try {
                String imageB64 = base64Encode(foodImage!.readAsBytesSync());
                param['image'] = imageB64;
              } catch (e) {
                DeviceUtils.toastMessage("error is ${e.toString()}");
              }
            }
            param['name'] = restaurantController.text.toString();
            param['contact'] = contactController.text.toString();
            param['cuisine_id'] = data!.cuisineId.toString();
            param['address'] = addressController.text.toString();
            param['min_order_amount'] =
                minOrderAmountController.text.toString();
            param['for_two_person'] = costOfTwoPersonController.text.toString();
            param['avg_delivery_time'] =
                avgDeliveryTimeController.text.toString();
            param['license_number'] =
                businessLicenseNumberController.text.toString();
            var vType;
            if (vendorTypeValue == 'All') {
              vType = 'all';
            } else if (vendorTypeValue == 'Pure Veg') {
              vType = 'veg';
            } else if (vendorTypeValue == 'None Veg') {
              vType = 'non_veg';
            } else {
              vType = 'non_applicable';
            }
            param['vendor_type'] = vType.toString();
            String timeSlotValueApi = '';
            if (timeSlotValue == '15 mins' ||
                timeSlotValue == '30 mins' ||
                timeSlotValue == '45 mins') {
              if (timeSlotValue == '15 mins') {
                timeSlotValueApi = '15';
              } else if (timeSlotValue == '30 mins') {
                timeSlotValueApi = '30';
              } else {
                timeSlotValueApi = '45';
              }
            } else {
              if (timeSlotValue == "1 Hour") {
                timeSlotValue = '60';
              } else if (timeSlotValue == "2 Hour") {
                timeSlotValue = '120';
              } else if (timeSlotValue == "3 Hour") {
                timeSlotValue = '180';
              } else if (timeSlotValue == "4 Hour") {
                timeSlotValue = '240';
              } else if (timeSlotValue == "5 Hour") {
                timeSlotValue = '300';
              }
            }

            param['time_slot'] = timeSlotValueApi;

            print(param.toString());
            setState(() {
              isProgress = true;
            });
            await updateProfileVendor(param).then((value) {
              if (value.data != null) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              } else {
                isProgress = false;
              }
              setState(() {});
            });
          }
        },
        child: Container(
          color: Palette.green,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Center(
            child: Text(
              getTranslated(context, change_information)!,
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

  pickImageFromCamera(ImageSource source) {
    this.setState(() async {
      ImagePicker imagePicker = ImagePicker();
      await imagePicker.pickImage(source: source).then((value) {
        foodImage = File(value!.path);
        setState(() {});
      });
    });
  }

  pickImageFromGallery(ImageSource source) {
    this.setState(() async {
      ImagePicker imagePicker = ImagePicker();
      await imagePicker.pickImage(source: source).then((value) {
        foodImage = File(value!.path);
        setState(() {});
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
                        pickImageFromGallery(ImageSource.gallery);
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

