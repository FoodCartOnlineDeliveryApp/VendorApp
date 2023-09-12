import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<MyCashBalanceResponse>> getCashBalance() async {
  MyCashBalanceResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).cashBalance();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}


class MyCashBalanceResponse {
  bool? _success;
  Data? _data;

  bool? get success => _success;
  Data? get data => _data;

  MyCashBalanceResponse({
      bool? success, 
      Data? data}){
    _success = success;
    _data = data;
}

  MyCashBalanceResponse.fromJson(dynamic json) {
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
  List<Balance>? _balance;
  int? _totalBalance;

  List<Balance>? get balance => _balance;
  int? get totalBalance => _totalBalance;

  Data({
    List<Balance>? balance,
    int? totalBalance}){
    _balance = balance;
    _totalBalance = totalBalance;
  }

  Data.fromJson(dynamic json) {
    if (json["balance"] != null) {
      _balance = [];
      json["balance"].forEach((v) {
        _balance!.add(Balance.fromJson(v));
      });
    }
    _totalBalance = json["total_balance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_balance != null) {
      map["balance"] = _balance!.map((v) => v.toJson()).toList();
    }
    map["total_balance"] = _totalBalance;
    return map;
  }

}

class Balance {
  String? _orderId;
  num? _amount;
  String? _date;
  String? _name;

  String? get orderId => _orderId;
  num? get amount => _amount;
  String? get date => _date;
  String? get name => _name;

  Balance({
    String? orderId,
    num? amount,
    String? date,
    String? name}){
    _orderId = orderId;
    _amount = amount;
    _date = date;
    _name = name;
  }

  Balance.fromJson(dynamic json) {
    _orderId = json["order_id"];
    _amount = json["amount"];
    _date = json["date"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["order_id"] = _orderId;
    map["amount"] = _amount;
    map["date"] = _date;
    map["name"] = _name;
    return map;
  }

}