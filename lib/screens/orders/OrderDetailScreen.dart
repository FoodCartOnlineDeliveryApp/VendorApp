import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/models/orders_response.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  Data? data;

  OrderDetailScreen(Data data) {
    this.data = data;
  }

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState(data);
}

String currencySymbol = '';

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Data? data;
  double subTotal = 0.0;
  List<dynamic>? listTextData;

  _OrderDetailScreenState(Data? data) {
    this.data = data;
  }

  @override
  void initState() {
    currencySymbol = SharedPreferenceHelper.getString(Preferences.currency_symbol);
    for (int i = 0; i < data!.orderItems!.length; i++) {
      subTotal = subTotal + data!.orderItems![i].price!;
    }
    listTextData = jsonDecode(data!.tax!);
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
        title: Center(
          child: Column(
            children: [
              Text(
                '${data!.orderId}',
                style: TextStyle(fontFamily: "ProximaBold", color: Palette.loginhead, fontSize: 17),
              ),
              Text(
                '${data!.date} , ${data!.time}',
                style: TextStyle(fontFamily: "ProximaBold", color: Palette.loginhead, fontSize: 11),
              ),
            ],
          ),
        ),
        actions: [Image.asset("assets/images/check.png")],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.png'))),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            data!.userName!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: proxima_nova_reg,
                                fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            child: Image.asset("assets/images/call.png"),
                          ),
                          onTap: () {
                            launch("tel://${data!.userPhone}");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                        child: ListView.builder(
                          itemCount: data!.orderItems!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index1) {
                            return Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data!.orderItems![index1].itemName!,
                                            style: TextStyle(
                                                color: Palette.loginhead,
                                                fontFamily: "ProximaNova",
                                                fontSize: 14),
                                          ),
                                          Text(
                                            ' x ${data!.orderItems![index1].qty}',
                                            style: TextStyle(
                                                color: Palette.green,
                                                fontFamily: "ProximaBold",
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        child: Text(
                                          '(Extra Veggies, Extra Cheese)',
                                          style: TextStyle(
                                              color: Palette.switchs,
                                              fontFamily: proxima_nova_reg,
                                              fontSize: 12),
                                        ),
                                        visible: false,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$currencySymbol ${data!.orderItems![index1].price.toString()}',
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontFamily: proxima_nova_reg,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal ",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 15,
                                  fontFamily: "ProximaNova"),
                            ),
                            Text(
                              "$currencySymbol$subTotal",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 15,
                                  fontFamily: "ProximaBold"),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Applied Coupon",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 15,
                                  fontFamily: "ProximaNova"),
                            ),
                            Text(
                              "-$currencySymbol${data!.promoCodePrice}",
                              style: TextStyle(
                                  color: Palette.removeacct,
                                  fontSize: 15,
                                  fontFamily: "ProximaBold"),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Text(
                            "FPAR1223F(30%)",
                            style: TextStyle(
                                color: Palette.green, fontSize: 15, fontFamily: "ProximaBold"),
                          ),
                        ),
                        visible: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listTextData!.length,
                          itemBuilder: (context, index) {
                            return listTextData!.length > 0
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${listTextData![index]['name']}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Palette.loginhead,
                                              fontFamily: proxima_nova_reg),
                                        ),
                                        Text(
                                          "$currencySymbol${listTextData![index]['tax'].toString()}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Palette.loginhead,
                                              fontFamily: "ProximaNova"),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total",
                              style: TextStyle(
                                  color: Palette.green, fontSize: 15, fontFamily: "ProximaBold"),
                            ),
                            Text(
                              "$currencySymbol${data!.amount}",
                              style: TextStyle(
                                  color: Palette.green, fontSize: 15, fontFamily: "ProximaBold"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                data!.deliveryType == 'HOME' && data!.deliveryPersonId != null
                    ? Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          )
                        ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15), color: Colors.white),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data!.deliveryPerson!.firstName! + ' ' + data!.deliveryPerson!.lastName!,
                                          style: TextStyle(
                                              color: Palette.loginhead,
                                              fontSize: 15,
                                              fontFamily: "ProximaBold"),
                                        ),
                                        Text(
                                          data!.deliveryPerson!.contact ?? '',
                                          style: TextStyle(
                                              color: Palette.switchs,
                                              fontSize: 15,
                                              fontFamily: "ProximaNova"),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: GestureDetector(
                                onTap: () {
                                  launch("tel://${data!.deliveryPerson!.contact}");
                                },
                                child: Container(
                                  child: Image.asset("assets/images/call.png"),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SHOP
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: 100.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 2),
                                child: Image.asset("assets/images/from.png")),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 70.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SharedPreferenceHelper.getString(Preferences.name),
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontFamily: proxima_nova_bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    data!.vendorAddress ?? '',
                                    style: TextStyle(
                                        color: Palette.switchs,
                                        fontFamily: proxima_nova_reg,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      data!.deliveryType == 'HOME' && data!.userAddress != null
                          ? Container(
                              width: 100.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 10, top: 2),
                                      child: Image.asset("assets/images/two.png")),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 70.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Home",
                                          style: TextStyle(
                                              color: Palette.loginhead,
                                              fontFamily: "ProximaBold",
                                              fontSize: 16),
                                        ),
                                        Text(
                                            data!.userAddress!,
                                          style: TextStyle(
                                              color: Palette.switchs,
                                              fontFamily: proxima_nova_reg,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
