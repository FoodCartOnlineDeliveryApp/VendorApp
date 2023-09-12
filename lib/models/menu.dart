import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<Menu>> getMenu() async {
  Menu response;
  try {
    response = await ApiClient(ApiHeader().dioData()).menu();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class Menu {
  bool? _success;
  List<Data?>? _data;

  bool? get success => _success;
  List<Data?>? get data => _data;

  Menu({
      bool? success, 
      List<Data?>? data}){
    _success = success;
    _data = data;
}

  Menu.fromJson(dynamic json) {
    _success = json["success"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    if (_data != null) {
      map["data"] = _data!.map((v) => v!.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? _id;
  String? _name;
  String? _image;
  int? _status;

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  int? get status => _status;

  Data({
      int? id,
      String? name,
      String? image, 
      int? status}){
    _id = id;
    _name = name;
    _image = image;
    _status = status;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _image = json["image"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["image"] = _image;
    map["status"] = _status;
    return map;
  }

}