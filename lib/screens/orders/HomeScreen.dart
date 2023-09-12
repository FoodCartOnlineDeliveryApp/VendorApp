import 'dart:collection';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/orders_response.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/screens/auth/LoginScreen.dart';
import 'package:mealup_restaurant_side/screens/orders/OrderDetailScreen.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

Future<BaseModel<OrdersResponse>>? getOrderFuture;
List<Data> orderList = [];
List<Data> _searchResult = [];
int selectedIndex = 0;
TabController? controllerTab;
TextEditingController searchController = new TextEditingController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Data> orderList = [];
  List<Data> orderListPast = [];

  List<String> gender = [];

  @override
  void initState() {
    controllerTab = TabController(initialIndex: 0, length: 2, vsync: this);
    controllerTab!.addListener(() {
      setState(() {
        selectedIndex = controllerTab!.index;
      });
    });
    super.initState();

    getOrderFuture = getOrders();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      getOrderFuture = getOrders();
    });
  }

  List<String> select = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          getTranslated(context, orders)!,
          style: TextStyle(fontFamily: "ProximaBold", color: Palette.loginhead),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: controllerTab,
          unselectedLabelColor: Colors.black,
          indicatorColor: Palette.green,
          labelColor: Colors.black,
          indicatorWeight: 5,
          unselectedLabelStyle:
              TextStyle(fontSize: 18, fontFamily: proxima_nova_reg),
          labelStyle: TextStyle(fontSize: 18, fontFamily: proxima_nova_bold),
          tabs: [
            Text(getTranslated(context, new_orders)!),
            Text(getTranslated(context, past_orders)!)
          ],
        ),
      ),
      body: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'))),
        child: FutureBuilder<BaseModel<OrdersResponse>>(
          future: getOrderFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.data == null) {
                  if (snapshot.data!.error
                      .getErrorMessage()
                      .toString()
                      .contains('Unauthenticated.')) {
                    //clear session and logout
                    SharedPreferenceHelper.clearPref();
                    Future.delayed(
                        Duration.zero, () => dialogUnauthenticated(context));
                  }
                  return Center(
                      child: Container(
                          child: Text(snapshot.data!.error.getErrorMessage())));
                } else {
                  orderList.clear();
                  orderListPast.clear();
                  for (int i = 0; i < snapshot.data!.data!.data!.length; i++) {
                    if (snapshot.data!.data!.data![i].orderStatus ==
                            'COMPLETE' ||
                        snapshot.data!.data!.data![i].orderStatus == 'CANCEL' ||
                        snapshot.data!.data!.data![i].orderStatus == 'REJECT') {
                      orderListPast.add(snapshot.data!.data!.data![i]);
                    } else {
                      orderList.add(snapshot.data!.data!.data![i]);
                    }
                  }
                  return _tabBar(context);
                }
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

  _tabBar(BuildContext context) => TabBarView(controller: controllerTab, children: [

        /// new order
        RefreshIndicator(
            color: Palette.green,
            onRefresh: _refreshProducts,
            child: Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(
                      height: orderList.isEmpty
                          ? MediaQuery.of(context).size.height * 0.200
                          : 0,
                    ),
                    orderList.isEmpty
                        ? Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/noOrder.png',
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width:
                                        MediaQuery.of(context).size.width / 2),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "No any Order found right now.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: proxima_nova_bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                          )
                        : newOrderList(context)
                  ],
                )
              ],
            )),

        /// past order
        SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.70),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70.w,
                            child: TextField(
                              controller: searchController,
                              onChanged: onSearchTextChanged,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search Order ID or Username...',
                                  hintStyle: TextStyle(
                                      color: Palette.switchs,
                                      fontSize: 13,
                                      fontFamily: proxima_nova_reg)),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70.h,
                child: RefreshIndicator(
                    onRefresh: _refreshProducts,
                    color: Palette.green,
                    child: searchController.text.isNotEmpty
                        ? _searchResult.isEmpty
                            ? ListView(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),
                                  Container(
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/noOrder.png',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "No any Order found.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: proxima_nova_bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : ListView.builder(
                                itemCount: _searchResult.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  String? dropdownValue =
                                      _searchResult[index].orderStatus;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetailScreen(
                                                    _searchResult[index]),
                                          ));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white24, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "OID:",
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        _searchResult[index]
                                                            .orderId!,
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        " | ",
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        '${_searchResult[index].date}, ${_searchResult[index].time}',
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        _searchResult[index]
                                                            .userName!,
                                                        style: TextStyle(
                                                            color: Palette
                                                                .loginhead,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 16),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right_outlined,
                                                        color:
                                                            Palette.loginhead,
                                                        size: 35,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          DottedLine(
                                            direction: Axis.horizontal,
                                            lineThickness: 1.0,
                                            dashColor: Palette.switchs,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10,
                                                top: 10),
                                            child: ListView.builder(
                                              itemCount: _searchResult[index]
                                                  .orderItems!
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index1) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            _searchResult[index]
                                                                .orderItems![
                                                                    index1]
                                                                .itemName!,
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .loginhead,
                                                                fontFamily:
                                                                    "ProximaNova",
                                                                fontSize: 14),
                                                          ),
                                                          Text(
                                                            ' x ${_searchResult[index].orderItems![index1].qty}',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .green,
                                                                fontFamily:
                                                                    "ProximaBold",
                                                                fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      Visibility(
                                                        child: Text(
                                                          '(${_searchResult[index].orderItems![index1].itemName})',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .switchs,
                                                              fontFamily:
                                                                  "ProximaNova",
                                                              fontSize: 12),
                                                        ),
                                                        visible: false,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          DottedLine(
                                            direction: Axis.horizontal,
                                            lineThickness: 1.0,
                                            dashColor: Palette.switchs,
                                          ),
                                          Container(
                                            width: 100.w,
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10,
                                                top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 30.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _searchResult[index]
                                                            .paymentType!,
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${_searchResult[index].amount}',
                                                        style: TextStyle(
                                                            color: Palette
                                                                .loginhead,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Stack(children: [
                                                  Container(
                                                    width: 20.w,
                                                    child: DropdownButton(
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
                                                            color:
                                                                Palette.green,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 12),
                                                        onChanged:
                                                            (dynamic newValue) {
                                                          setState(() {
                                                            dropdownValue =
                                                                newValue;
                                                            Map<String, String?>
                                                                param =
                                                                new HashMap();
                                                            param['id'] =
                                                                _searchResult[index].id.toString();
                                                            param['status'] = dropdownValue;
                                                            FutureBuilder<
                                                                BaseModel<CommonResponse>>(
                                                              future: changeOrderStatus(
                                                                      param),
                                                              builder: (context,
                                                                  snapshot) {
                                                                DeviceUtils
                                                                    .toastMessage(
                                                                        'before connection ');
                                                                if (snapshot
                                                                        .connectionState !=
                                                                    ConnectionState
                                                                        .done) {
                                                                  return DeviceUtils
                                                                      .showProgress(
                                                                          true);
                                                                } else {
                                                                  print(
                                                                      '${snapshot.data!.data}');
                                                                  var data =
                                                                      snapshot
                                                                          .data!
                                                                          .data;
                                                                  print(data);
                                                                  setState(
                                                                      () {});
                                                                  if (data !=
                                                                      null) {
                                                                    return Container(
                                                                      child: DeviceUtils.toastMessage(data
                                                                          .data
                                                                          .toString()),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                        child: DeviceUtils.toastMessage(data!
                                                                            .data
                                                                            .toString()));
                                                                  }
                                                                }
                                                              },
                                                            );
                                                          });
                                                        },
                                                        items: _searchResult[
                                                                        index]
                                                                    .deliveryType ==
                                                                'SHOP'
                                                            ? <String>[
                                                                'Pending',
                                                                'Approve',
                                                                'Reject',
                                                                'PREPARE_FOR_ORDER',
                                                                'READY_FOR_ORDER',
                                                                'COMPLETE'
                                                              ].map((item) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  child: Text(
                                                                      item),
                                                                  value: item,
                                                                );
                                                              }).toList()
                                                            : <String>[
                                                                'Pending',
                                                                'Approve',
                                                                'Reject',
                                                                'PICKUP',
                                                                'DELIVERED',
                                                                'COMPLETE'
                                                              ].map((item) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  child: Text(
                                                                      item),
                                                                  value: item,
                                                                );
                                                              }).toList()),
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              right: 5),
                                                      child: Text(
                                                        dropdownValue!,
                                                        style: TextStyle(
                                                            color:
                                                                Palette.green,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 12),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                        : orderListPast.length != 0
                            ? ListView.builder(
                                itemCount: orderListPast.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  String dropdownValue =
                                      orderListPast[index].orderStatus!;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetailScreen(
                                                    orderListPast[index]),
                                          ));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white24, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "OID:",
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        orderListPast[index]
                                                            .orderId!,
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        " | ",
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        '${orderListPast[index].date}, ${orderListPast[index].time}',
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        orderListPast[index]
                                                            .userName!,
                                                        style: TextStyle(
                                                            color: Palette
                                                                .loginhead,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 16),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right_outlined,
                                                        color:
                                                            Palette.loginhead,
                                                        size: 35,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          DottedLine(
                                            direction: Axis.horizontal,
                                            lineThickness: 1.0,
                                            dashColor: Palette.switchs,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10,
                                                top: 10),
                                            child: ListView.builder(
                                              itemCount: orderListPast[index]
                                                  .orderItems!
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index1) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            orderListPast[index]
                                                                .orderItems![
                                                                    index1]
                                                                .itemName!,
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .loginhead,
                                                                fontFamily:
                                                                    "ProximaNova",
                                                                fontSize: 14),
                                                          ),
                                                          Text(
                                                            ' x ${orderListPast[index].orderItems![index1].qty}',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .green,
                                                                fontFamily:
                                                                    "ProximaBold",
                                                                fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      Visibility(
                                                        child: Text(
                                                          '(${orderListPast[index].orderItems![index1].itemName})',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .switchs,
                                                              fontFamily:
                                                                  "ProximaNova",
                                                              fontSize: 12),
                                                        ),
                                                        visible: false,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          DottedLine(
                                            direction: Axis.horizontal,
                                            lineThickness: 1.0,
                                            dashColor: Palette.switchs,
                                          ),
                                          Container(
                                            width: 100.w,
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10,
                                                top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 30.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        orderListPast[index]
                                                            .paymentType!,
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                proxima_nova_reg,
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${SharedPreferenceHelper.getString(Preferences.currency_symbol)}${orderListPast[index].amount}',
                                                        style: TextStyle(
                                                            color: Palette
                                                                .loginhead,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Stack(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, right: 5),
                                                    child: Text(
                                                      dropdownValue,
                                                      style: TextStyle(
                                                          color: Palette.green,
                                                          fontFamily:
                                                              proxima_nova_bold,
                                                          fontSize: 12),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  )
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.200,
                                  ),
                                  Container(
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/noOrder.png',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "No any Order right now.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: proxima_nova_bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                    ),
              ),
            ],
          ),
        ),
      ]);

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    orderListPast.forEach((order) {
      if (order.userName!.contains(text) || order.orderId!.contains(text))
        _searchResult.add(order);
    });
    print(_searchResult.length.toString());
    setState(() {});
  }

  newOrderList(BuildContext context) => ListView.builder(
        itemCount: orderList.length,
        physics:NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index) {
          String? dropdownValue = orderList[index].orderStatus;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(orderList[index]),
                  ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "OID:",
                                style: TextStyle(
                                    color: Palette.switchs,
                                    fontFamily: proxima_nova_reg,
                                    fontSize: 12),
                              ),
                              Text(
                                orderList[index].orderId!,
                                style: TextStyle(
                                    color: Palette.switchs,
                                    fontFamily: proxima_nova_reg,
                                    fontSize: 12),
                              ),
                              Text(
                                " | ",
                                style: TextStyle(
                                    color: Palette.switchs,
                                    fontFamily: proxima_nova_reg,
                                    fontSize: 12),
                              ),
                              Text(
                                '${orderList[index].date}, ${orderList[index].time}',
                                style: TextStyle(
                                    color: Palette.switchs,
                                    fontFamily: proxima_nova_reg,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orderList[index].userName!,
                                style: TextStyle(
                                    color: Palette.loginhead,
                                    fontFamily: proxima_nova_bold,
                                    fontSize: 16),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Palette.loginhead,
                                size: 35,
                              )
                            ],
                          ),
                        ],
                      )),
                  DottedLine(
                    direction: Axis.horizontal,
                    lineThickness: 1.0,
                    dashColor: Palette.switchs,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: ListView.builder(
                      itemCount: orderList[index].orderItems!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index1) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    orderList[index]
                                        .orderItems![index1]
                                        .itemName!,
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontFamily: "ProximaNova",
                                        fontSize: 14),
                                  ),
                                  Text(
                                    ' x ${orderList[index].orderItems![index1].qty}',
                                    style: TextStyle(
                                        color: Palette.green,
                                        fontFamily: "ProximaBold",
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              Visibility(
                                child: Text(
                                  '(${orderList[index].orderItems![index1].itemName})',
                                  style: TextStyle(
                                      color: Palette.switchs,
                                      fontFamily: "ProximaNova",
                                      fontSize: 12),
                                ),
                                visible: false,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  DottedLine(
                    direction: Axis.horizontal,
                    lineThickness: 1.0,
                    dashColor: Palette.switchs,
                  ),
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 30.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderList[index].paymentType!,
                                style: TextStyle(
                                    color: Palette.switchs,
                                    fontFamily: proxima_nova_reg,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${SharedPreferenceHelper.getString(Preferences.currency_symbol)} ${orderList[index].amount}',
                                style: TextStyle(
                                    color: Palette.loginhead,
                                    fontFamily: proxima_nova_bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showCupertinoModalBottomSheet(
                              expand: false,
                              context: context,
                              backgroundColor: Palette.white,
                              builder: (context) => deliveryZone(
                                  select, orderList[index].id, this),
                            );
                            setState(() {
                              select.clear();
                              orderList[index].orderStatus == 'PENDING'
                                  ? select = ['APPROVE', 'REJECT']
                                  : orderList[index].orderStatus != 'CANCEL' &&
                                          orderList[index].orderStatus !=
                                              'REJECT' &&
                                          orderList[index].orderStatus !=
                                              'COMPLETE'
                                      ? orderList[index].deliveryType == 'SHOP'
                                          ? select = [
                                              'PREPARE_FOR_ORDER',
                                              'READY_FOR_ORDER',
                                              'COMPLETE'
                                            ]
                                          : select = [
                                              'PICKUP',
                                              'DELIVERED',
                                              'COMPLETE'
                                            ]
                                      : select = [];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Text(
                                  orderList[index].orderStatus.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontFamily: proxima_nova_bold,
                                  ),
                                ),
                                SizedBox(),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  dialogUnauthenticated(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(0),
                color: Palette.green,
                child: Center(
                    child: Text(
                  getTranslated(context, alert)!,
                  style: TextStyle(
                      fontFamily: proxima_nova_bold,
                      color: Palette.white,
                      fontSize: 14),
                )),
              ),
            ),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          getTranslated(context, your_session_expired)!,
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontFamily: proxima_nova_bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.green),
              child: Text(
                getTranslated(context, ok)!,
                style: TextStyle(
                    fontFamily: proxima_nova_bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}

Widget deliveryZone(List<String> select, int? id, _HomeScreenState _homeScreenState) {
  return Material(
    child: StatefulBuilder(
      builder: (context, setState) {
        Future<void> _refreshProducts() async {
          _homeScreenState.setState(() {
            getOrderFuture = getOrders();
          });
        }

        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Change order status",
                          style: TextStyle(color: Colors.green, fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Colors.green,
                        dashRadius: 0.0,
                        dashGapLength: 0,
                        dashGapColor: Palette.white,
                        dashGapRadius: 0,
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: select.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    Map<String, String?> param = new HashMap();
                                    param['id'] = id.toString();
                                    param['status'] = select[index];
                                    changeOrderStatus(param);
                                    _refreshProducts();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Text(
                                        select[index],
                                        style: TextStyle(
                                            color: Palette.switchs,
                                            fontFamily: proxima_nova_reg,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineThickness: 1.0,
                                  dashColor: Palette.switchs,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}