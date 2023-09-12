import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

Future<BaseModel<AddAndUpdateCustomizationItem>> addAndUpdateCustomizationItem( int? id,Map<String, dynamic> param,) async {
  AddAndUpdateCustomizationItem response;
  try {
    response = await ApiClient(ApiHeader().dioData()).addAndUpdateCustomizationItem(id,param);
    DeviceUtils.toastMessage(response.msg!);
  } catch (error, stacktrace) {
    print("Exception occurred: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class AddAndUpdateCustomizationItem {
  bool? success;
  String? msg;

  AddAndUpdateCustomizationItem({this.success, this.msg});

  AddAndUpdateCustomizationItem.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    return data;
  }
}
