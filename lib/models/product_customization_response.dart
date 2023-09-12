import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';


Future<BaseModel<ProductCustomizationResponse>> getCustomization(int? id) async {
  ProductCustomizationResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).getCustomization(id);
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}


class ProductCustomizationResponse {
  bool? _success;
  List<CustomizationData>? _customizationData;

  bool? get success => _success;
  List<CustomizationData>? get customizationData => _customizationData;

  ProductCustomizationResponse({
      bool? success, 
      List<CustomizationData>? customizationData}){
    _success = success;
    _customizationData = customizationData;
}

  ProductCustomizationResponse.fromJson(dynamic json) {
    _success = json["success"];
    if (json["data"] != null) {
      _customizationData = [];
      json["data"].forEach((v) {
        _customizationData!.add(CustomizationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    if (_customizationData != null) {
      map["data"] = _customizationData!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class CustomizationData {
  int? _id;
  String? _name;
  int? _vendorId;
  int? _submenuId;
  int? _menuId;
  String? _type;
  int? _minItemSelection;
  int? _maxItemSelection;
  String? _custimazationItem;

  int? get id => _id;
  String? get name => _name;
  int? get vendorId => _vendorId;
  int? get submenuId => _submenuId;
  int? get menuId => _menuId;
  String? get type => _type;
  int? get minItemSelection => _minItemSelection;
  int? get maxItemSelection => _maxItemSelection;
  String? get custimazationItem => _custimazationItem;

  CustomizationData({
      int? id, 
      String? name, 
      int? vendorId, 
      int? submenuId, 
      int? menuId, 
      String? type, 
      int? minItemSelection, 
      int? maxItemSelection, 
      String? custimazationItem}){
    _id = id;
    _name = name;
    _vendorId = vendorId;
    _submenuId = submenuId;
    _menuId = menuId;
    _type = type;
    _minItemSelection = minItemSelection;
    _maxItemSelection = maxItemSelection;
    _custimazationItem = custimazationItem;
}

  CustomizationData.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _vendorId = json["vendor_id"];
    _submenuId = json["submenu_id"];
    _menuId = json["menu_id"];
    _type = json["type"];
    _minItemSelection = json["min_item_selection"];
    _maxItemSelection = json["max_item_selection"];
    _custimazationItem = json["custimazation_item"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["vendor_id"] = _vendorId;
    map["submenu_id"] = _submenuId;
    map["menu_id"] = _menuId;
    map["type"] = _type;
    map["min_item_selection"] = _minItemSelection;
    map["max_item_selection"] = _maxItemSelection;
    map["custimazation_item"] = _custimazationItem;
    return map;
  }

}