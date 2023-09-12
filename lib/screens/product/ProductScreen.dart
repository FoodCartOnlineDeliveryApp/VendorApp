import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealup_restaurant_side/AddAndEditCustomization.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/delete_subMenu.dart';
import 'package:mealup_restaurant_side/models/menu_and_submenu.dart';
import 'package:mealup_restaurant_side/models/product_customization_response.dart';
import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'AddNewItem.dart';
import 'customeTabView.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>  with TickerProviderStateMixin {

  int selectedIndex = 0;
  int initPosition = 0;
  Future<BaseModel<MenuAndSubmenu>>? menuFuture;
  MenuAndSubmenuData? dropdownValue;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    menuFuture = getMenuAndSubmenu();
  }

  bool isShowProgress = false;

  Future<void> _refreshProduct() async {
    setState(() {
      menuFuture = getMenuAndSubmenu();
    });
  }

  // Customization Item //
  List<MClass> controllerClassList = [];
  List<Widget> data = [];
  var listData;

  bool change = false;
  MenuAndSubmenu menuAndSubmenuData = MenuAndSubmenu();

  String stock = "";

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
            getTranslated(context, my_products)!,
            style: TextStyle(
                fontFamily: proxima_nova_bold, color: Palette.loginhead),
          ),
        ),
        body: Container(
            width: width,
            height: height,
            margin: EdgeInsets.all(10),
            child: FutureBuilder<BaseModel<MenuAndSubmenu>>(
              future: menuFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return DeviceUtils.showProgress(true);
                } else {

                  var data = snapshot.data!.data!;
                  menuAndSubmenuData=snapshot.data!.data!;

                  if (data.data!.length != 0) {
                    SharedPreferenceHelper.setInt(
                        Preferences.tab_index, data.data![0].id!);
                    dropdownValue = data.data![0];
                  }
                  return data.data!.length > 0
                      ? CustomTabView(
                          initPosition: initPosition,
                          itemCount:
                              data.data!.length > 1 ? data.data!.length : 1,
                          tabBuilder: (context, index) =>
                              Tab(text: data.data![index].name),
                          pageBuilder: (context, index) =>
                              _productList(data.data![index].submenu,this),
                          onPositionChange: (index) {
                            initPosition = index!;
                            SharedPreferenceHelper.setInt(Preferences.tab_index, data.data![index].id!);
                            SharedPreferenceHelper.getInt(Preferences.tab_index);
                            dropdownValue = data.data![index];
                          },
                          onScroll: (position) => print('$position'),
                          onMenuEdit: (bool value) {
                            if (value == true) {
                              _refreshProduct();
                            }
                          },
                        )
                      : Center(
                          child: Container(child: Text('No Data To Show')),
                        );
                }
              },
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Palette.green,
          onPressed: () {
            menuAndSubmenuData.data?.length != 0?
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewItem(dropdownValue, false, null)),
            ):_displayAddMenuDialog(context);
          },
          child: Icon(
            Icons.add,
            color: Palette.white,
          ),
        ),
      ),
    );
  }

  _productList(List<Submenu>? submenu, _ProductScreenState _productScreenState) {
    final controller = ValueNotifier<bool>(false);
    // AdvancedSwitchController _controller = AdvancedSwitchController();
    return RefreshIndicator(
      color: Palette.green,
      onRefresh: _refreshProduct,
      child: StatefulBuilder(
        builder: (context,myState){
          return Container(
              height: 100.h,
              width: 100.w,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'))),
                  child: submenu!.length != 0 ?
                  ListView.builder(
                      itemCount: submenu.length,
                      itemBuilder: (context, index) {
                        controller.value = submenu[index].status == 1
                            ? true
                            : false;
                        controller.addListener(() {
                          if (submenu[index].status == 1) {
                            Map<String, String> param = new HashMap();
                            param['menu_id'] = submenu[index].menuId.toString();
                            param['name'] = submenu[index].name.toString();
                            param['description'] =
                                submenu[index].description.toString();
                            param['type'] = submenu[index].type.toString();
                            param['qty_reset'] = submenu[index].qtyReset.toString();
                            param['price'] = submenu[index].price.toString();
                            param['status'] = '0';
                            if (submenu[index].itemResetValue != null) {
                              param['item_reset_value'] =
                                  submenu[index].itemResetValue.toString();
                            } else {
                              param['item_reset_value'] = '0';
                            }
                            DeviceUtils.showProgress(true);
                            updateSubmenu(submenu[index].id, param).then((value) {
                              myState((){
                                submenu[index].status = 0;
                              });
                              controller.value = false;
                              DeviceUtils.showProgress(false);
                            });
                          } else {
                            Map<String, String> param = new HashMap();
                            param['menu_id'] = submenu[index].menuId.toString();
                            param['name'] = submenu[index].name.toString();
                            param['description'] =
                                submenu[index].description.toString();
                            param['type'] = submenu[index].type.toString();
                            param['qty_reset'] = submenu[index].qtyReset.toString();
                            param['price'] = submenu[index].price.toString();
                            param['status'] = '1';
                            if (submenu[index].itemResetValue != null) {
                              param['item_reset_value'] =
                                  submenu[index].itemResetValue.toString();
                            } else {
                              param['item_reset_value'] = "0";
                            }
                            DeviceUtils.showProgress(true);
                            updateSubmenu(submenu[index].id, param).then((value) {
                              myState((){
                                submenu[index].status = 1;
                              });
                              controller.value = true;
                              DeviceUtils.showProgress(false);
                            });
                          }
                        });
                        return GestureDetector(
                          onTap: () {
                            showModelSheet(submenu[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            width: 100.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    child: Image(
                                      image: NetworkImage(submenu[index].image!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 48.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          submenu[index].type == 'veg'
                                              ? SvgPicture.asset(
                                              'assets/images/veg.svg')
                                              : SvgPicture.asset(
                                              'assets/images/nonveg.svg'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width:
                                            MediaQuery.of(context).size.width /
                                                2.48,
                                            child: Text(
                                              submenu[index].name!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Palette.loginhead,
                                                  fontSize: 16,
                                                  fontFamily: proxima_nova_bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        submenu[index].description!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Palette.switchs,
                                            fontSize: 12,
                                            fontFamily: proxima_nova_reg),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${SharedPreferenceHelper.getString(Preferences.currency_symbol)} ${submenu[index].price}',
                                            style: TextStyle(
                                                color: Palette.loginhead,
                                                fontSize: 16,
                                                fontFamily: proxima_nova_reg),
                                          ),
                                          Text(
                                            "  |  ",
                                            style: TextStyle(
                                                color: Palette.loginhead,
                                                fontSize: 16,
                                                fontFamily: proxima_nova_reg),
                                          ),
                                          PopupMenuButton(
                                            padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.more_horiz,
                                                color: Palette.green,
                                                size: 40,
                                              ),
                                              itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry>[
                                                PopupMenuItem(
                                                  child: Text(
                                                    "Edit Sub-menu",
                                                    style: TextStyle(
                                                        color: Palette.green,
                                                        fontSize: 16,
                                                        fontFamily:
                                                        proxima_nova_reg),
                                                  ),
                                                  value: 0,
                                                ),
                                                PopupMenuItem(
                                                  child: Text(
                                                    "Delete Sub-menu",
                                                    style: TextStyle(
                                                        color: Palette.green,
                                                        fontSize: 16,
                                                        fontFamily:
                                                        proxima_nova_reg),
                                                  ),
                                                  value: 1,
                                                ),
                                              ],
                                              onSelected: (dynamic values) {
                                                if (values == 0) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddNewItem(null, true,
                                                                  submenu[index])));
                                                } else if (values == 1) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          insetPadding:
                                                          EdgeInsets.all(10),
                                                          title: Text(
                                                            "Are you want to sure Delete Sub-menu ?",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                proxima_nova_reg,
                                                                fontSize: 16),
                                                          ),
                                                          content: Container(
                                                            height: 40,
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                TextButton(
                                                                  child: Text(
                                                                    "No",
                                                                    style: TextStyle(
                                                                        color: Palette
                                                                            .green),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(
                                                                        color: Palette
                                                                            .green),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    DeleteSubMenu res = await ApiClient(
                                                                        ApiHeader()
                                                                            .dioData())
                                                                        .deleteSubmenu(
                                                                        submenu[index]
                                                                            .id);
                                                                    if (res.success ==
                                                                        true) {
                                                                      setState(() {
                                                                        _refreshProduct();
                                                                        DeviceUtils
                                                                            .toastMessage(
                                                                            "Sub-menu deleted successfully...!!");
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                              }),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddAndEditCustomization(
                                                        submenu: submenu[index],
                                                      )));
                                        },
                                        child: Container(
                                            height: 25,
                                            width: 130,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Palette.green,
                                                borderRadius: BorderRadius.circular(10)),

                                            child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8.sp,
                                                      fontFamily: proxima_nova_bold,

                                                    ),
                                                    text: '${getTranslated(context, add_customization_options)!.substring(0,3)} ',
                                                    children: [
                                                      TextSpan(
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8.sp,
                                                            fontFamily: proxima_nova_bold,
                                                          ),
                                                          text: getTranslated(context, add_customization_options)!.substring(4,18))
                                                    ]))
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: AdvancedSwitch(
                                        controller: controller,
                                        activeColor: Palette.green,
                                        inactiveColor: Palette.removeacct,
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(5)),
                                        width: 20.w,
                                        height: 10.w,
                                        enabled: true,
                                        disabledOpacity: 0.5,
                                      ),
                                    ),
                                    Container(
                                      width: 03.w,
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: submenu[index].status == 1
                                            ? Text(
                                          "IN STOCK",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Palette.green),
                                        )
                                            : Text(
                                          "OUT OF STOCK",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Palette.removeacct),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }) :
                  ListView(
                    children: [
                      SizedBox(
                        height:  MediaQuery.of(context).size.height * 0.2 ,
                      ),
                      Container(
                        height:  200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/noOrder.png',
                                height: MediaQuery.of(context).size.height/6,
                                width: MediaQuery.of(context).size.width/2),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No any Product found.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: proxima_nova_bold, fontSize: 18),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ));
        },
      )

    );
  }

  showModelSheet(Submenu submenu) async {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Palette.sheet,
      context: context,
      elevation: 10,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Column(
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: 100.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 18.w,
                        height: 20.w,
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image(
                            image: NetworkImage(submenu.image!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: 48.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                submenu.type == 'veg'
                                    ? SvgPicture.asset('assets/images/veg.svg')
                                    : SvgPicture.asset(
                                        'assets/images/nonveg.svg'),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.48,
                                  child: Text(
                                    submenu.name!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontSize: 16,
                                        fontFamily: proxima_nova_bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              submenu.description!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Palette.switchs,
                                  fontSize: 12,
                                  fontFamily: proxima_nova_reg),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${SharedPreferenceHelper.getString(Preferences.currency_symbol)} ${submenu.price}',
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_reg),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: AdvancedSwitch(
                              controller: submenu.status == 1
                                  ? ValueNotifier<bool>(true)
                                  : ValueNotifier<bool>(false),
                              activeColor: Palette.green,
                              inactiveColor: Palette.removeacct,
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(5)),
                              width: 20.w,
                              height: 10.w,
                              enabled: false,
                              disabledOpacity: 0.5,
                            ),
                          ),
                          Container(
                            width: 03.w,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child:
                                  Text(
                                "$stock",
                                style: TextStyle(
                                    fontSize: 10, color: Palette.removeacct),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, customization_list)!,
                        style: TextStyle(
                            fontSize: 16,
                            color: Palette.loginhead,
                            fontFamily: proxima_nova_bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddAndEditCustomization(
                                          submenu: submenu,
                                        )));
                          });
                        },
                        child: Text(
                          getTranslated(context, edit_customization_list)!,
                          style: TextStyle(
                              fontSize: 16,
                              color: Palette.blue,
                              fontFamily: "ProximaNova"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 100.w,
                  height: 70.w,
                  child: FutureBuilder<BaseModel<ProductCustomizationResponse>>(
                    future: getCustomization(submenu.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState !=
                            ConnectionState.waiting) {
                          return snapshot
                                      .data!.data!.customizationData!.length >
                                  0
                              ? ListView.builder(
                                  itemCount: snapshot
                                      .data!.data!.customizationData!.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot
                                            .data!
                                            .data!
                                            .customizationData![index]
                                            .custimazationItem !=
                                        null) {
                                      listData = jsonDecode(snapshot
                                          .data!
                                          .data!
                                          .customizationData![index]
                                          .custimazationItem!);
                                      if (listData.length != null) {
                                        controllerClassList.clear();
                                        for (int i = 0;
                                            i < listData.length;
                                            i++) {
                                          controllerClassList.add(MClass(
                                              TextEditingController(
                                                  text: listData[i]['name']),
                                              TextEditingController(
                                                  text: listData[i]['price']),
                                              listData[i]['isDefault'] == 1
                                                  ? true
                                                  : false,
                                              listData[i]['status'] == 1
                                                  ? true
                                                  : false));
                                        }
                                      }
                                    }
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          alignment: AlignmentDirectional.topStart,
                                          child: Text(
                                            "${snapshot.data!.data!.customizationData![index].name}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Palette.green,
                                                fontFamily: "ProximaBold"),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                controllerClassList.length,
                                            itemBuilder: (context, i) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      listData[i]['name'],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Palette.loginhead,
                                                          fontFamily:
                                                              proxima_nova_reg),
                                                    ),
                                                    Text(
                                                      "${SharedPreferenceHelper.getString(Preferences.currency_symbol)}" +
                                                          " " +
                                                          listData[i]['price'],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Palette.loginhead,
                                                          fontFamily:
                                                              proxima_nova_reg),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(getTranslated(
                                      context, data_not_available)!));
                        }
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddNewItem(null, true, submenu)));
                },
                child: Container(
                  color: Palette.green,
                  height: 40,
                  width: 100.w,
                  child: Center(
                    child: Text(
                      getTranslated(context, edit_this_product)!,
                      style: TextStyle(
                          fontSize: 15,
                          color: Palette.white,
                          fontFamily: proxima_nova_reg),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  // ADD MENU //
  Future<void> _displayAddMenuDialog(BuildContext context) async {
    File? _image;
    TextEditingController _textMenuNameController = TextEditingController();
    final advancedSwitchController = ValueNotifier<bool>(false);
    // AdvancedSwitchController advancedSwitchController =
    // AdvancedSwitchController();
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
                color: Palette.loginhead,
                child: Center(
                    child: Text(
                      getTranslated(context, add_menu)!,
                      style: TextStyle(
                          fontFamily: proxima_nova_bold,
                          color: Colors.white,
                          fontSize: 14),
                    )),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter dialogState) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  margin: EdgeInsets.only(left: 0, right: 0),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    child: _image != null
                                        ? Image.file(
                                      _image!,
                                      fit: BoxFit.fill,
                                    )
                                        : SvgPicture.asset(
                                      'assets/images/no_image.svg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    dialogState(() {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return SafeArea(
                                              child: Container(
                                                child: new Wrap(
                                                  children: <Widget>[
                                                    new ListTile(
                                                        leading: new Icon(
                                                            Icons.photo_library),
                                                        title: new Text(
                                                            'Photo Library'),
                                                        onTap: () async {
                                                          final pickedFile =
                                                          await _picker.pickImage(
                                                              source:
                                                              ImageSource
                                                                  .gallery,
                                                              imageQuality: 50);

                                                          dialogState(() {
                                                            _image = File(
                                                                pickedFile!.path);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                    new ListTile(
                                                      leading: new Icon(
                                                          Icons.photo_camera),
                                                      title: new Text('Camera'),
                                                      onTap: () async {
                                                        final pickedFile =
                                                        await _picker.pickImage(
                                                            source: ImageSource
                                                                .camera,
                                                            imageQuality: 50);

                                                        dialogState(() {
                                                          _image = File(
                                                              pickedFile!.path);
                                                        });
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        color: Palette.green,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 30.w,
                                        child: Text(
                                          getTranslated(
                                              context, add_food_item_image)!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Palette.green,
                                              fontSize: 12,
                                              fontFamily: "ProximaNova"),
                                        ),
                                      )
                                    ],
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
                                Text(
                                  getTranslated(context, menu_name)!,
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_bold),
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
                                            left: 10, right: 10, top: 0, bottom: 0),
                                        child: TextField(
                                          controller: _textMenuNameController,
                                          cursorColor: Palette.loginhead,
                                          decoration: InputDecoration(
                                              hintText:
                                              getTranslated(context, menu_name),
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
                            Align(
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
                            Align(
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
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.green),
              child: Text(
                'Close',
                style: TextStyle(
                    fontFamily: proxima_nova_bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.green),
              child: Text(
                'Save',
                style: TextStyle(
                    fontFamily: proxima_nova_bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
              onPressed: () async {
                if (_textMenuNameController.text.isEmpty) {
                  setState(() {
                    DeviceUtils.toastMessage(
                        getTranslated(context, empty_error_text)!);
                  });
                } else {
                  Map<String, String> param = new HashMap();
                  String passScreenshotImage;
                  if (_image != null) {
                    try {
                      List<int> imageBytes = _image!.readAsBytesSync();
                      String imageB64 = base64Encode(imageBytes);
                      passScreenshotImage = imageB64;
                      param['image'] = passScreenshotImage;
                    } catch (e) {
                      DeviceUtils.toastMessage("error is ${e.toString()}");
                    }
                  }
                  param['name'] = _textMenuNameController.text.toString();
                  param['status'] =
                  advancedSwitchController.value == true ? '1' : '0';
                  setState(() {
                    isShowProgress = true;
                  });
                  CommonResponse res =
                  await ApiClient(ApiHeader().dioData()).createMenu(param);
                  if (res.success!) {
                    setState(() {
                      isShowProgress = false;
                      DeviceUtils.toastMessage(res.data!);
                      _refreshProduct();
                      Navigator.pop(context);
                    });
                  }
                }
              },
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