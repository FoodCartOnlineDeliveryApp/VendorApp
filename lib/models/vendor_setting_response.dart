import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<VendorSettingResponse>> getVendorDetail() async {
  VendorSettingResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).vendorSetting();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;

}



class VendorSettingResponse {
  bool? _success;
  Data? _data;

  bool? get success => _success;
  Data? get data => _data;

  VendorSettingResponse({
      bool? success, 
      Data? data}){
    _success = success;
    _data = data;
}

  VendorSettingResponse.fromJson(dynamic json) {
    _success = json["success"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }

}

class Data {
  String? _vendorAppId;
  String? _vendorAuthKey;
  String? _vendorApiKey;
  String? _currency;
  String? _currencySymbol;

  String? get vendorAppId => _vendorAppId;
  String? get vendorAuthKey => _vendorAuthKey;
  String? get vendorApiKey => _vendorApiKey;
  String? get currency => _currency;
  String? get currencySymbol => _currencySymbol;

  Data({
      String? vendorAppId, 
      String? vendorAuthKey, 
      String? vendorApiKey, 
      String? currency, 
      String? currencySymbol}){
    _vendorAppId = vendorAppId;
    _vendorAuthKey = vendorAuthKey;
    _vendorApiKey = vendorApiKey;
    _currency = currency;
    _currencySymbol = currencySymbol;
}

  Data.fromJson(dynamic json) {
    _vendorAppId = json["vendor_app_id"];
    _vendorAuthKey = json["vendor_auth_key"];
    _vendorApiKey = json["vendor_api_key"];
    _currency = json["currency"];
    _currencySymbol = json["currency_symbol"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["vendor_app_id"] = _vendorAppId;
    map["vendor_auth_key"] = _vendorAuthKey;
    map["vendor_api_key"] = _vendorApiKey;
    map["currency"] = _currency;
    map["currency_symbol"] = _currencySymbol;
    return map;
  }

}