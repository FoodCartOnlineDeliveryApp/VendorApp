import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<InsightsResponse>> getInsights() async {
  InsightsResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).insights();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class InsightsResponse {
  InsightsResponse({
      this.success, 
      this.data,});

  InsightsResponse.fromJson(dynamic json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.todayOrder, 
      this.totalOrder, 
      this.totalEarnings, 
      this.todayEarnings, 
      this.totalMenu, 
      this.totalSubmenu, 
      this.orderChart, 
      this.earningChart,});

  Data.fromJson(dynamic json) {
    todayOrder = json['today_order'];
    totalOrder = json['total_order'];
    totalEarnings = json['total_earnings'];
    todayEarnings = json['today_earnings'];
    totalMenu = json['total_menu'];
    totalSubmenu = json['total_submenu'];
    if (json['order_chart'] != null) {
      orderChart = [];
      json['order_chart'].forEach((v) {
        orderChart?.add(Order_chart.fromJson(v));
      });
    }
    if (json['earning_chart'] != null) {
      earningChart = [];
      json['earning_chart'].forEach((v) {
        earningChart?.add(Earning_chart.fromJson(v));
      });
    }
  }
  int? todayOrder;
  int? totalOrder;
  int? totalEarnings;
  int? todayEarnings;
  int? totalMenu;
  int? totalSubmenu;
  List<Order_chart>? orderChart;
  List<Earning_chart>? earningChart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['today_order'] = todayOrder;
    map['total_order'] = totalOrder;
    map['total_earnings'] = totalEarnings;
    map['today_earnings'] = todayEarnings;
    map['total_menu'] = totalMenu;
    map['total_submenu'] = totalSubmenu;
    if (orderChart != null) {
      map['order_chart'] = orderChart?.map((v) => v.toJson()).toList();
    }
    if (earningChart != null) {
      map['earning_chart'] = earningChart?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Earning_chart {
  Earning_chart({
      this.data, 
      this.label,});

  Earning_chart.fromJson(dynamic json) {
    data = json['data'];
    label = json['label'];
  }
  int? data;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    map['label'] = label;
    return map;
  }

}

class Order_chart {
  Order_chart({
      this.data, 
      this.label,});

  Order_chart.fromJson(dynamic json) {
    data = json['data'];
    label = json['label'];
  }
  int? data;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    map['label'] = label;
    return map;
  }

}