import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/constant/app_strings.dart';
import 'package:mealup_restaurant_side/localization/localization_constant.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/delete_menu.dart';
import 'package:mealup_restaurant_side/models/menu_and_submenu.dart';
import 'package:mealup_restaurant_side/models/single_menu_detail.dart';
import 'package:mealup_restaurant_side/models/update_menu.dart';
import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:sizer/sizer.dart';

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget? stub;
  final ValueChanged<int?>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;
  ValueChanged<bool> onMenuEdit;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
    required this.onMenuEdit,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController? controller;
  int? _currentCount;
  int? _currentPosition;
  Future<BaseModel<MenuAndSubmenu>>? menuFuture;

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
      currentBackPressTime = now;
    return Future.value(true);
  }

  // add menu //
  File? _image;
  final ImagePicker _picker = ImagePicker();

  bool isShowProgress = false;


  @override
  void initState() {
    _currentPosition = 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition!,
    );
    controller!.addListener(onPositionChange);
    controller!.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller!.animation!.removeListener(onScroll);
      controller!.removeListener(onPositionChange);
      controller!.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition! > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition! < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller!.addListener(onPositionChange);
        controller!.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller!.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller!.animation!.removeListener(onScroll);
    controller!.removeListener(onPositionChange);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                child: TabBar(
                  isScrollable: true,
                  controller: controller,
                  labelStyle: TextStyle(fontFamily: proxima_nova_bold, fontSize: 18),
                  labelColor: Palette.loginhead,
                  unselectedLabelColor: Palette.loginhead,
                  unselectedLabelStyle: TextStyle(fontFamily: proxima_nova_reg,fontSize: 16),
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Palette.green,
                        width: 4,
                      ),
                    ),
                  ),
                  tabs: List.generate(
                    widget.itemCount,
                    (index) => widget.tabBuilder(context, index),
                  ),
                ),
              ),
            ),
            PopupMenuButton(
                icon: Icon(
                  Icons.add,
                  color: Palette.green,
                  size: 30,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text(
                      "Add Menu",
                      style: TextStyle(
                          color: Palette.green,
                          fontSize: 16,
                          fontFamily: proxima_nova_reg),
                    ),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Edit Menu",
                      style: TextStyle(
                          color: Palette.green,
                          fontSize: 16,
                          fontFamily: proxima_nova_reg),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Remove Menu",
                      style: TextStyle(
                          color: Palette.green,
                          fontSize: 16,
                          fontFamily: proxima_nova_reg),
                    ),
                    value: 2,
                  ),
                ],
                onSelected: (dynamic values) {
                  if (values == 0) {
                    _displayAddMenuDialog(context);
                  } else if (values == 1) {
                    _displayEditMenuDialog(context);
                  } else if (values == 2) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(10),
                            title: Text(
                              "Are you want to sure Delete item ?",
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
                                      setState(() async {
                                        print("ID ");
                                      DeleteMenu res = await ApiClient(ApiHeader().dioData()).deleteMenu(SharedPreferenceHelper.getInt(Preferences.tab_index));
                                      if(res.success == true){
                                        setState(() {
                                          DeviceUtils.toastMessage("Menu deleted successfully...!!");
                                          widget.onMenuEdit(true);
                                          Navigator.pop(context);
                                        });
                                        // onWillPop();
                                      }else{
                                        DeviceUtils.toastMessage("Menu not deleted");
                                        widget.onMenuEdit(true);
                                        Navigator.pop(context);
                                      }
                                      });
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
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller!.indexIsChanging) {
      _currentPosition = controller!.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller!.animation!.value);
    }
  }


  // ADD MENU //
  Future<void> _displayAddMenuDialog(BuildContext context) async {
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
              style: ElevatedButton.styleFrom(backgroundColor: Palette.green),
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
              style: ElevatedButton.styleFrom(backgroundColor: Palette.green),
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
                      widget.onMenuEdit(true);
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

  // EDIT MENU //
  Future<void> _displayEditMenuDialog(BuildContext context) async {
    TextEditingController _textMenuNameController = TextEditingController();
    final advancedSwitchController =ValueNotifier<bool>(false);
    // AdvancedSwitchController advancedSwitchController =
    // AdvancedSwitchController();
    return showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<BaseModel<SingleMenuDetail>>(
          future: singleMenuDetail(SharedPreferenceHelper.getInt(Preferences.tab_index),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                _textMenuNameController.text = snapshot.data!.data!.data!.name!;
                advancedSwitchController.value = snapshot.data!.data!.data!.status! == 1 ? true : false;
                String? image = snapshot.data!.data!.data!.image!;
                return snapshot.data!.data!.data != null
                    ? AlertDialog(
                  titlePadding: EdgeInsets.all(0),
                  contentPadding:
                  EdgeInsets.only(left: 20, right: 20, top: 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white24, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
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
                    child: StatefulBuilder(builder:
                        (BuildContext context, StateSetter dialogState) {
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
                                      margin: EdgeInsets.only(
                                          left: 0, right: 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: _image != null
                                            ? Image.file(
                                          _image!,
                                          fit: BoxFit.fill,
                                        )
                                            : CachedNetworkImage(
                                          alignment:
                                          Alignment.center,
                                          imageUrl: image,
                                          imageBuilder: (context,
                                              imageProvider) =>
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundColor:
                                                Palette.white,
                                                child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage:
                                                  imageProvider,
                                                ),
                                              ),
                                          placeholder: (context,
                                              url) =>
                                              SpinKitFadingCircle(
                                                  color: Palette
                                                      .green),
                                          errorWidget: (context,
                                              url, error) =>
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        10)),
                                                child: Image.asset(
                                                    "assets/images/no_image.svg"),
                                              ),
                                          // height: 85,
                                          // width: 85,
                                          // fit: BoxFit.fitHeight,
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
                                                                Icons
                                                                    .photo_library),
                                                            title: new Text(
                                                                'Photo Library'),
                                                            onTap:
                                                                () async {
                                                              final pickedFile = await _picker.pickImage(
                                                                  source: ImageSource
                                                                      .gallery,
                                                                  imageQuality:
                                                                  50);

                                                              dialogState(
                                                                      () {
                                                                    _image = File(
                                                                        pickedFile!
                                                                            .path);
                                                                  });
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            }),
                                                        new ListTile(
                                                          leading: new Icon(
                                                              Icons
                                                                  .photo_camera),
                                                          title: new Text(
                                                              'Camera'),
                                                          onTap:
                                                              () async {
                                                            final pickedFile = await _picker.pickImage(
                                                                source: ImageSource
                                                                    .camera,
                                                                imageQuality:
                                                                50);

                                                            dialogState(
                                                                    () {
                                                                  _image = File(
                                                                      pickedFile!
                                                                          .path);
                                                                });
                                                            Navigator.of(
                                                                context)
                                                                .pop();
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
                                              getTranslated(context,
                                                  add_food_item_image)!,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Palette.green,
                                                  fontSize: 12,
                                                  fontFamily:
                                                  "ProximaNova"),
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black12,
                                                width: 1),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            child: TextField(
                                              controller:
                                              _textMenuNameController,
                                              cursorColor:
                                              Palette.loginhead,
                                              decoration: InputDecoration(
                                                  hintText: getTranslated(
                                                      context, menu_name),
                                                  hintStyle: TextStyle(
                                                      color:
                                                      Palette.switchs,
                                                      fontSize: 16),
                                                  border:
                                                  InputBorder.none),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
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
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(5)),
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
                      style: ElevatedButton.styleFrom(
                          primary: Palette.green),
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
                      style: ElevatedButton.styleFrom(
                          primary: Palette.green),
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
                            // restaurantError = empty_error_text;
                            DeviceUtils.toastMessage(getTranslated(
                                context, empty_error_text)!);
                          });
                        } else {
                          Map<String, String> param = new HashMap();
                          String passScreenshotImage;
                          if (_image != null) {
                            try {
                              List<int> imageBytes =
                              _image!.readAsBytesSync();
                              String imageB64 = base64Encode(imageBytes);
                              passScreenshotImage = imageB64;
                              param['image'] = passScreenshotImage;
                            } catch (e) {
                              DeviceUtils.toastMessage(
                                  "error is ${e.toString()}");
                            }
                          }
                          param['name'] =
                              _textMenuNameController.text.toString();
                          param['status'] =
                          advancedSwitchController.value == true
                              ? '1'
                              : '0';
                          setState(() {
                            isShowProgress = true;
                          });
                          UpdateMenu res =
                          await ApiClient(ApiHeader().dioData())
                              .updateMenu(
                              SharedPreferenceHelper.getInt(
                                  Preferences.tab_index),
                              param);
                          if (res.success!) {
                            setState(() {
                              isShowProgress = false;
                              // _refreshProduct();
                              DeviceUtils.toastMessage(res.data!);
                              widget.onMenuEdit(true);
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                    ),
                  ],
                )
                    : Center(
                    child:
                    Text(getTranslated(context, data_not_available)!));
              } else {
                return DeviceUtils.showProgress(true);
              }
            } else {
              return DeviceUtils.showProgress(true);
            }
          },
        );
      },
    );
  }
}