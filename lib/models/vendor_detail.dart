import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<VendorDetail>> getVendorDetails() async {
  VendorDetail response;
  try {
    response = await ApiClient(ApiHeader().dioData()).vendorDetail();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class VendorDetail {
  bool? success;
  Data? data;

  VendorDetail({this.success, this.data});

  VendorDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? name;
  String? vendorLogo;
  String? emailId;
  String? image;
  String? password;
  String? contact;
  String? cuisineId;
  String? address;
  String? lat;
  String? lang;
  String? mapAddress;
  dynamic minOrderAmount;
  dynamic forTwoPerson;
  dynamic avgDeliveryTime;
  dynamic licenseNumber;
  String? adminComissionType;
  String? adminComissionValue;
  String? vendorType;
  String? timeSlot;
  dynamic tax;
  dynamic deliveryTypeTimeSlot;
  int? isExplorer;
  int? isTop;
  int? vendorOwnDriver;
  dynamic paymentOption;
  int? status;
  String? vendorLanguage;
  dynamic connectorType;
  dynamic connectorDescriptor;
  dynamic connectorPort;
  String? createdAt;
  String? updatedAt;
  List<Cuisine>? cuisine;
  int? rate;
  int? review;

  Data(
      {this.id,
        this.userId,
        this.name,
        this.vendorLogo,
        this.emailId,
        this.image,
        this.password,
        this.contact,
        this.cuisineId,
        this.address,
        this.lat,
        this.lang,
        this.mapAddress,
        this.minOrderAmount,
        this.forTwoPerson,
        this.avgDeliveryTime,
        this.licenseNumber,
        this.adminComissionType,
        this.adminComissionValue,
        this.vendorType,
        this.timeSlot,
        this.tax,
        this.deliveryTypeTimeSlot,
        this.isExplorer,
        this.isTop,
        this.vendorOwnDriver,
        this.paymentOption,
        this.status,
        this.vendorLanguage,
        this.connectorType,
        this.connectorDescriptor,
        this.connectorPort,
        this.createdAt,
        this.updatedAt,
        this.cuisine,
        this.rate,
        this.review});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    vendorLogo = json['vendor_logo'];
    emailId = json['email_id'];
    image = json['image'];
    password = json['password'];
    contact = json['contact'];
    cuisineId = json['cuisine_id'];
    address = json['address'];
    lat = json['lat'];
    lang = json['lang'];
    mapAddress = json['map_address'];
    minOrderAmount = json['min_order_amount'];
    forTwoPerson = json['for_two_person'];
    avgDeliveryTime = json['avg_delivery_time'];
    licenseNumber = json['license_number'];
    adminComissionType = json['admin_comission_type'];
    adminComissionValue = json['admin_comission_value'];
    vendorType = json['vendor_type'];
    timeSlot = json['time_slot'];
    tax = json['tax'];
    deliveryTypeTimeSlot = json['delivery_type_timeSlot'];
    isExplorer = json['isExplorer'];
    isTop = json['isTop'];
    vendorOwnDriver = json['vendor_own_driver'];
    paymentOption = json['payment_option'];
    status = json['status'];
    vendorLanguage = json['vendor_language'];
    connectorType = json['connector_type'];
    connectorDescriptor = json['connector_descriptor'];
    connectorPort = json['connector_port'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json["cuisine"] != null) {
      cuisine = [];
        json["cuisine"].forEach((v) {
          cuisine!.add(Cuisine.fromJson(v));
        });
    }
    rate = json['rate'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['vendor_logo'] = this.vendorLogo;
    data['email_id'] = this.emailId;
    data['image'] = this.image;
    data['password'] = this.password;
    data['contact'] = this.contact;
    data['cuisine_id'] = this.cuisineId;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['map_address'] = this.mapAddress;
    data['min_order_amount'] = this.minOrderAmount;
    data['for_two_person'] = this.forTwoPerson;
    data['avg_delivery_time'] = this.avgDeliveryTime;
    data['license_number'] = this.licenseNumber;
    data['admin_comission_type'] = this.adminComissionType;
    data['admin_comission_value'] = this.adminComissionValue;
    data['vendor_type'] = this.vendorType;
    data['time_slot'] = this.timeSlot;
    data['tax'] = this.tax;
    data['delivery_type_timeSlot'] = this.deliveryTypeTimeSlot;
    data['isExplorer'] = this.isExplorer;
    data['isTop'] = this.isTop;
    data['vendor_own_driver'] = this.vendorOwnDriver;
    data['payment_option'] = this.paymentOption;
    data['status'] = this.status;
    data['vendor_language'] = this.vendorLanguage;
    data['connector_type'] = this.connectorType;
    data['connector_descriptor'] = this.connectorDescriptor;
    data['connector_port'] = this.connectorPort;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.cuisine != null) {
      data['cuisine'] = this.cuisine!.map((v) => v.toJson()).toList();
    }
    data['rate'] = this.rate;
    data['review'] = this.review;
    return data;
  }
}

class Cuisine {
  String? _name;
  String? _image;

  String? get name => _name;
  String? get image => _image;

  Cuisine({
    String? name,
    String? image}){
    _name = name;
    _image = image;
  }

  Cuisine.fromJson(dynamic json) {
    _name = json["name"];
    _image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["image"] = _image;
    return map;
  }
}