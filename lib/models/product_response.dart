import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';


Future<BaseModel<ProductResponse>> getProduct(int? id) async {
  ProductResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).subMenu(id);
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}


class ProductResponse {
  bool? _success;
  List<ProductData>? _productData;

  bool? get success => _success;
  List<ProductData>? get productData => _productData;

  ProductResponse({
      bool? success, 
      List<ProductData>? data}){
    _success = success;
    _productData = productData;
}

  ProductResponse.fromJson(dynamic json) {
    _success = json["success"];
    if (json["data"] != null) {
      _productData = [];
      json["data"].forEach((v) {
        _productData!.add(ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    if (_productData != null) {
      map["data"] = _productData!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ProductData {
  int? _id;
  int? _vendorId;
  int? _menuId;
  String? _name;
  String? _image;
  String? _price;
  String? _description;
  String? _type;
  String? _qtyReset;
  int? _status;
  int? _itemResetValue;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  int? get vendorId => _vendorId;
  int? get menuId => _menuId;
  String? get name => _name;
  String? get image => _image;
  String? get price => _price;
  String? get description => _description;
  String? get type => _type;
  String? get qtyReset => _qtyReset;
  int? get status => _status;
  int? get itemResetValue => _itemResetValue;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  ProductData({
      int? id, 
      int? vendorId, 
      int? menuId, 
      String? name, 
      String? image, 
      String? price, 
      String? description, 
      String? type, 
      String? qtyReset, 
      int? status, 
      int? itemResetValue, 
      String? createdAt, 
      String? updatedAt}){
    _id = id;
    _vendorId = vendorId;
    _menuId = menuId;
    _name = name;
    _image = image;
    _price = price;
    _description = description;
    _type = type;
    _qtyReset = qtyReset;
    _status = status;
    _itemResetValue = itemResetValue;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  ProductData.fromJson(dynamic json) {
    _id = json["id"];
    _vendorId = json["vendor_id"];
    _menuId = json["menu_id"];
    _name = json["name"];
    _image = json["image"];
    _price = json["price"];
    _description = json["description"];
    _type = json["type"];
    _qtyReset = json["qty_reset"];
    _status = json["status"];
    _itemResetValue = json["item_reset_value"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["vendor_id"] = _vendorId;
    map["menu_id"] = _menuId;
    map["name"] = _name;
    map["image"] = _image;
    map["price"] = _price;
    map["description"] = _description;
    map["type"] = _type;
    map["qty_reset"] = _qtyReset;
    map["status"] = _status;
    map["item_reset_value"] = _itemResetValue;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}