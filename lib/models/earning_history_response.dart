import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<EarningHistoryResponse>> getEarningHistory() async {
  EarningHistoryResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).earningHistory();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()
      ..setException(ServerError.withError(error: error));
  }
  return BaseModel()
    ..data = response;
}
class EarningHistoryResponse {
  EarningHistoryResponse({
      this.success, 
      this.data,});

  EarningHistoryResponse.fromJson(dynamic json) {
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
      this.totalBalance, 
      this.todayEarning, 
      this.weeklyEarning, 
      this.yearlyEarning, 
      this.earningChart,});

  Data.fromJson(dynamic json) {
    totalBalance = json['total_balance'];
    todayEarning = json['today_earning'];
    weeklyEarning = json['weekly_earning'];
    yearlyEarning = json['yearly_earning'];
    if (json['earning_chart'] != null) {
      earningChart = [];
      json['earning_chart'].forEach((v) {
        earningChart?.add(Earning_chart.fromJson(v));
      });
    }
  }
  int? totalBalance;
  int? todayEarning;
  int? weeklyEarning;
  int? yearlyEarning;
  List<Earning_chart>? earningChart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_balance'] = totalBalance;
    map['today_earning'] = todayEarning;
    map['weekly_earning'] = weeklyEarning;
    map['yearly_earning'] = yearlyEarning;
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