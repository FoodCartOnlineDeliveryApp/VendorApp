import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

Future<BaseModel<UpdateCustomization>> updateCustomization( int? id,Map<String, dynamic> param,) async {
  UpdateCustomization response;
  try {
    response = await ApiClient(ApiHeader().dioData()).updateCustimization(id,param);
    DeviceUtils.toastMessage(response.data.toString());
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class UpdateCustomization {
  bool? success;
  String? data;

  UpdateCustomization({this.success, this.data});

  UpdateCustomization.fromJson(Map<String, dynamic> json) {
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
