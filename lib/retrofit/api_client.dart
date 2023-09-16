import 'package:dio/dio.dart';
import 'package:mealup_restaurant_side/models/add_and_update_customization_item.dart';
import 'package:mealup_restaurant_side/models/common_response.dart';
import 'package:mealup_restaurant_side/models/create_customization.dart';
import 'package:mealup_restaurant_side/models/delete_customization.dart';
import 'package:mealup_restaurant_side/models/delete_menu.dart';
import 'package:mealup_restaurant_side/models/delete_subMenu.dart';
import 'package:mealup_restaurant_side/models/earning_history_response.dart';
import 'package:mealup_restaurant_side/models/faq_response.dart';
import 'package:mealup_restaurant_side/models/insights_response.dart';
import 'package:mealup_restaurant_side/models/menu.dart';
import 'package:mealup_restaurant_side/models/menu_and_submenu.dart';
import 'package:mealup_restaurant_side/models/my_cash_balance_response.dart';
import 'package:mealup_restaurant_side/models/orders_response.dart';
import 'package:mealup_restaurant_side/models/product_customization_response.dart';
import 'package:mealup_restaurant_side/models/product_response.dart';
import 'package:mealup_restaurant_side/models/single_menu_detail.dart';
import 'package:mealup_restaurant_side/models/update_customization.dart';
import 'package:mealup_restaurant_side/models/update_menu.dart';
import 'package:mealup_restaurant_side/models/user.dart';
import 'package:mealup_restaurant_side/models/vendor_detail.dart';
import 'package:mealup_restaurant_side/models/vendor_setting_response.dart';
import 'package:mealup_restaurant_side/retrofit/apis.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';


@RestApi(baseUrl: 'https://www.foodcartonline.in/api/vendor/')
//Please don't remove "/api/vendor/".
abstract class ApiClient {

  factory ApiClient(Dio dio,{String? baseUrl}) = _ApiClient;

  @POST(Apis.login)
  @FormUrlEncoded()
  Future<User> login(@Field('email_id') String email,@Field('password') String password,@Field('device_token') String deviceToken);

  @POST(Apis.register)
  @FormUrlEncoded()
  Future<User> register(@Body()  Map<String,String> param);

  @GET(Apis.menu)
  Future<Menu> menu();

  @GET(Apis.menuAndSubmenu)
  Future<MenuAndSubmenu> menuAndSubmenu();

  @POST(Apis.createMenu)
  @FormUrlEncoded()
  Future<CommonResponse> createMenu(@Body()  Map<String,String> param);

  @GET('${Apis.subMenu}/{id}')
  Future<ProductResponse> subMenu(@Path() int? id);

  @POST(Apis.createSubmenu)
  @FormUrlEncoded()
  Future<CommonResponse> createSubmenu(@Body()  Map<String,String?> param);

  @GET(Apis.orders)
  Future<OrdersResponse> orders();

  @GET(Apis.insights)
  Future<InsightsResponse> insights();

  @GET(Apis.cashBalance)
  Future<MyCashBalanceResponse> cashBalance();

  @GET(Apis.earningHistory)
  Future<EarningHistoryResponse> earningHistory();

  @GET(Apis.faq)
  Future<FaqResponse> faq();

  @POST(Apis.changeStatus)
  @FormUrlEncoded()
  Future<CommonResponse> changeStatus(@Body()  Map<String,String?> param);


  @GET('${Apis.customization}/{id}')
  Future<ProductCustomizationResponse> getCustomization(
      @Path() int? id);

  @POST('${Apis.updateSubmenu}/{id}')
  @FormUrlEncoded()
  Future<CommonResponse> updateSubmenu(@Path() int? id , @Body()  Map<String,String?> param);

  @POST(Apis.updateProfile)
  @FormUrlEncoded()
  Future<CommonResponse> updateProfile(@Body() Map<String,String> param);

  @GET(Apis.vendorDetail)
  Future<VendorDetail> vendorDetail();

  @GET(Apis.vendorSetting)
  Future<VendorSettingResponse> vendorSetting();

  @POST(Apis.changePassword)
  @FormUrlEncoded()
  Future<CommonResponse> changePassword(@Body() Map<String,String> param);

  @POST(Apis.checkOTP)
  @FormUrlEncoded()
  Future<User> checkOTP(@Body() Map<String,String> param);

  @POST(Apis.resendOTP)
  @FormUrlEncoded()
  Future<User> resendOTP(@Body() Map<String,String> param);

  @GET('${Apis.deleteCustimization}/{id}')
  Future<DeleteCustomization> deleteCustimization(@Path() int? id);

  @POST('${Apis.updateCustimization}/{id}')
  Future<UpdateCustomization> updateCustimization(@Path() int? id,@Body()  Map<String,dynamic> param);

  @POST('${Apis.createCustimization}')
  Future<CreateCustomization> createCustimization(@Body()  Map<String,dynamic> param);

  @POST('${Apis.updateCustomizationItem}/{id}')
  Future<AddAndUpdateCustomizationItem> addAndUpdateCustomizationItem(@Path() int? id,@Body()  Map<String,dynamic> param);

  @GET('${Apis.singleMenuDetail}/{id}')
  Future<SingleMenuDetail> singleMenuDetail(@Path() int? id);

  @POST('${Apis.updateMenu}/{id}')
  Future<UpdateMenu> updateMenu(@Path() int? id,@Body()  Map<String,dynamic> param);

  @GET('${Apis.deleteMenu}/{id}')
  Future<DeleteMenu> deleteMenu(@Path() int? id);

  @GET('${Apis.deleteSubmenu}/{id}')
  Future<DeleteSubMenu> deleteSubmenu(@Path() int? id);
  @POST("firebase/token")
  Future<Map<String, dynamic>> addRemoveFCMToken(@Body() Map<String, dynamic> map);

}

