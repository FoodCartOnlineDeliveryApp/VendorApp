import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<FaqResponse>> getFaq() async {
  FaqResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).faq();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class FaqResponse {
  bool? _success;
  List<Data>? _data;

  bool? get success => _success;
  List<Data>? get data => _data;

  FaqResponse({
      bool? success, 
      List<Data>? data}){
    _success = success;
    _data = data;
}

  FaqResponse.fromJson(dynamic json) {
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
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  int? _id;
  String? _question;
  String? _type;
  String? _answer;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get question => _question;
  String? get type => _type;
  String? get answer => _answer;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Data({
      int? id, 
      String? question, 
      String? type, 
      String? answer, 
      String? createdAt, 
      String? updatedAt}){
    _id = id;
    _question = question;
    _type = type;
    _answer = answer;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _question = json["question"];
    _type = json["type"];
    _answer = json["answer"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["question"] = _question;
    map["type"] = _type;
    map["answer"] = _answer;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}