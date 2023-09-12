import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

  Future<BaseModel<MenuAndSubmenu>> getMenuAndSubmenu() async {
  MenuAndSubmenu response;
  try {
    response = await ApiClient(ApiHeader().dioData()).menuAndSubmenu();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class MenuAndSubmenu {
  bool? success;
  List<MenuAndSubmenuData>? data;

  MenuAndSubmenu({this.success, this.data});

  MenuAndSubmenu.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MenuAndSubmenuData>[];
      json['data'].forEach((v) {
        data!.add(new MenuAndSubmenuData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuAndSubmenuData {
  int? id;
  String? name;
  String? image;
  int? status;
  List<Submenu>? submenu;

  MenuAndSubmenuData({this.id, this.name, this.image, this.status, this.submenu});

  MenuAndSubmenuData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    if (json['submenu'] != null) {
      submenu = <Submenu>[];
      json['submenu'].forEach((v) {
        submenu!.add(new Submenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.submenu != null) {
      data['submenu'] = this.submenu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Submenu {
  int? id;
  int? vendorId;
  int? menuId;
  String? name;
  String? image;
  String? price;
  String? description;
  String? type;
  String? qtyReset;
  int? status;
  int? itemResetValue;
  int? isExcel;
  dynamic availabelItem;

  Submenu(
      {this.id,
        this.vendorId,
        this.menuId,
        this.name,
        this.image,
        this.price,
        this.description,
        this.type,
        this.qtyReset,
        this.status,
        this.itemResetValue,
        this.isExcel,
        this.availabelItem});

  Submenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    menuId = json['menu_id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    description = json['description'];
    type = json['type'];
    qtyReset = json['qty_reset'];
    status = json['status'];
    itemResetValue = json['item_reset_value'];
    isExcel = json['is_excel'];
    availabelItem = json['availabel_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['menu_id'] = this.menuId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['description'] = this.description;
    data['type'] = this.type;
    data['qty_reset'] = this.qtyReset;
    data['status'] = this.status;
    data['item_reset_value'] = this.itemResetValue;
    data['is_excel'] = this.isExcel;
    data['availabel_item'] = this.availabelItem;
    return data;
  }
}
