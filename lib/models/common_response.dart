import 'package:mealup_restaurant_side/models/user.dart';
import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

Future<BaseModel<CommonResponse>> addMenu(Map<String, String> param) async {
  CommonResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).createMenu(param);
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

Future<BaseModel<CommonResponse>> addProduct(Map<String, String?> param) async {
  CommonResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).createSubmenu(param);
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;

}

Future<BaseModel<CommonResponse>> changeOrderStatus(Map<String, String?> param) async {
  CommonResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).changeStatus(param);
    DeviceUtils.toastMessage(response.data.toString());
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

Future<BaseModel<CommonResponse>> updateSubmenu( int? id,Map<String, String?> param,) async {
  CommonResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).updateSubmenu(id,param);
    DeviceUtils.toastMessage(response.data.toString());
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

Future<BaseModel<CommonResponse>> updateProfileVendor(Map<String, String> param) async {
  CommonResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).updateProfile(param);
    DeviceUtils.toastMessage(response.data.toString());
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

Future<BaseModel<CommonResponse>> changePassword(Map<String, String> param) async {
  CommonResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).changePassword(param);
    DeviceUtils.toastMessage(response.data.toString());
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

Future<BaseModel<User>> checkOTP(Map<String, String> param) async {
  User response;
  try {
    response = await ApiClient(ApiHeader().dioData()).checkOTP(param);
    DeviceUtils.toastMessage(response.msg.toString());
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}


Future<BaseModel<User>> resendOTP(Map<String, String> param) async {
  User response;
  try {
    response = await ApiClient(ApiHeader().dioData()).resendOTP(param);
    DeviceUtils.toastMessage(response.msg.toString());
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class CommonResponse {
  bool? _success;
  String? _data;

  bool? get success => _success;
  String? get data => _data;

  CommonResponse({bool? success, String? data}){
    _success = success;
    _data = data;
}

  CommonResponse.fromJson(dynamic json) {
    _success = json["success"];
    _data = json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    map["data"] = _data;
    return map;
  }

}

