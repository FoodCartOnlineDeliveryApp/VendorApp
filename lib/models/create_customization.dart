import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

Future<BaseModel<CreateCustomization>> createCustomization(Map<String, dynamic> param) async {
  CreateCustomization response;
  try {
    response = await ApiClient(ApiHeader().dioData()).createCustimization(param);
    DeviceUtils.toastMessage(response.data.toString());
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class CreateCustomization {
  bool? success;
  String? data;

  CreateCustomization({this.success, this.data});

  CreateCustomization.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    return data;
  }
}
