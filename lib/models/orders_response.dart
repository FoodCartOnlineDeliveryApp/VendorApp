import 'package:mealup_restaurant_side/retrofit/api_client.dart';
import 'package:mealup_restaurant_side/retrofit/api_header.dart';
import 'package:mealup_restaurant_side/retrofit/base_model.dart';
import 'package:mealup_restaurant_side/retrofit/server_error.dart';

Future<BaseModel<OrdersResponse>> getOrders() async {
  OrdersResponse response;
  try {
    response = await ApiClient(ApiHeader().dioData()).orders();
  } catch (error, stacktrace) {
    print("Exception occur: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}


class OrdersResponse {
  bool? success;
  List<Data>? data;

  OrdersResponse({
      this.success, 
      this.data});

  OrdersResponse.fromJson(dynamic json) {
    success = json["success"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = success;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  int? id;
  String? orderId;
  int? vendorId;
  int? userId;
  dynamic deliveryPersonId;
  String? date;
  String? time;
  String? paymentType;
  dynamic paymentToken;
  String? paymentStatus;
  double? amount;
  dynamic adminCommission;
  dynamic vendorAmount;
  String? deliveryType;
  dynamic promoCodeId;
  double? promoCodePrice;
  dynamic vendorDiscountId;
  double? vendorDiscountPrice;
  dynamic addressId;
  dynamic deliveryCharge;
  String? orderStatus;
  dynamic cancelBy;
  dynamic cancelReason;
  String? tax;
  String? orderStartTime;
  String? orderEndTime;
  String? userName;
  String? userPhone;
  String? userAddress;
  DeliveryPerson? deliveryPerson;
  String? vendorAddress;
  List<OrderItems>? orderItems;

  Data({
      this.id, 
      this.orderId, 
      this.vendorId, 
      this.userId, 
      this.deliveryPersonId, 
      this.date, 
      this.time, 
      this.paymentType, 
      this.paymentToken, 
      this.paymentStatus, 
      this.amount, 
      this.adminCommission, 
      this.vendorAmount, 
      this.deliveryType, 
      this.promoCodeId,
      this.promoCodePrice,
      this.vendorDiscountId, 
      this.vendorDiscountPrice, 
      this.addressId, 
      this.deliveryCharge, 
      this.orderStatus, 
      this.cancelBy, 
      this.cancelReason, 
      this.tax, 
      this.orderStartTime, 
      this.orderEndTime, 
      this.userName, 
      this.userAddress,
      this.deliveryPerson,
      this.userPhone,
      this.vendorAddress,
      this.orderItems});

  Data.fromJson(dynamic json) {
    print(json["id"]);
    id = json["id"];
    orderId = json["order_id"];
    vendorId = json["vendor_id"];
    userId = json["user_id"];
    deliveryPersonId = json["delivery_person_id"];
    date = json["date"];
    time = json["time"];
    paymentType = json["payment_type"];
    paymentToken = json["payment_token"];
    paymentStatus = json["payment_status"];
    amount = json['amount'] != null ? json['amount'].toDouble() : 0.0;
    adminCommission = json["admin_commission"];
    vendorAmount = json["vendor_amount"];
    deliveryType = json["delivery_type"];
    promoCodeId = json["promocode_id"];
    promoCodePrice = json['promocode_price'] != null ? json['promocode_price'].toDouble() : 0.0;
    vendorDiscountId = json["vendor_discount_id"];
    vendorDiscountPrice = json['vendor_discount_price'] != null ? json['vendor_discount_price'].toDouble() : 0.0;
    addressId = json["address_id"];
    deliveryCharge = json["delivery_charge"];
    orderStatus = json["order_status"];
    cancelBy = json["cancel_by"];
    cancelReason = json["cancel_reason"];
    tax = json["tax"];
    orderStartTime = json["order_start_time"];
    orderEndTime = json["order_end_time"];
    userName = json["user_name"];
    userPhone = json["user_phone"];
    vendorAddress = json["vendorAddress"];
    userAddress = json["userAddress"];
    deliveryPerson = json["delivery_person"] != null ? DeliveryPerson.fromJson(json["delivery_person"]) : null;
    if (json["orderItems"] != null) {
      orderItems = [];
      json["orderItems"].forEach((v) {
        orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_id"] = orderId;
    map["vendor_id"] = vendorId;
    map["user_id"] = userId;
    map["delivery_person_id"] = deliveryPersonId;
    map["date"] = date;
    map["time"] = time;
    map["payment_type"] = paymentType;
    map["payment_token"] = paymentToken;
    map["payment_status"] = paymentStatus;
    map["amount"] = amount;
    map["admin_commission"] = adminCommission;
    map["vendor_amount"] = vendorAmount;
    map["delivery_type"] = deliveryType;
    map["promocode_id"] = promoCodeId;
    map["promocode_price"] = promoCodePrice;
    map["vendor_discount_id"] = vendorDiscountId;
    map["vendor_discount_price"] = vendorDiscountPrice;
    map["address_id"] = addressId;
    map["delivery_charge"] = deliveryCharge;
    map["order_status"] = orderStatus;
    map["cancel_by"] = cancelBy;
    map["cancel_reason"] = cancelReason;
    map["tax"] = tax;
    map["order_start_time"] = orderStartTime;
    map["order_end_time"] = orderEndTime;
    map["user_name"] = userName;
    map["user_phone"] = userPhone;
    map["vendorAddress"] = vendorAddress;
    map["userAddress"] = userAddress;
    if (deliveryPerson != null) {
      map["delivery_person"] = deliveryPerson?.toJson();
    }
    if (orderItems != null) {
      map["orderItems"] = orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class OrderItems {
  int? id;
  int? orderId;
  int? item;
  double? price;
  int? qty;
  dynamic customization;
  String? createdAt;
  String? updatedAt;
  String? itemName;

  OrderItems({
      this.id, 
      this.orderId, 
      this.item, 
      this.price, 
      this.qty, 
      this.customization,
      this.createdAt, 
      this.updatedAt, 
      this.itemName});

  OrderItems.fromJson(dynamic json) {
    id = json["id"];
    orderId = json["order_id"];
    item = json["item"];
    price = json['price'] != null ? json['price'].toDouble() : 0.0;
    qty = json["qty"];
    customization = json["custimization"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    itemName = json["itemName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_id"] = orderId;
    map["item"] = item;
    map["price"] = price;
    map["qty"] = qty;
    map["custimization"] = customization;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["itemName"] = itemName;
    return map;
  }

}

class DeliveryPerson {
  String? firstName;
  String? lastName;
  String? contact;

  DeliveryPerson({
    this.firstName,
    this.lastName,
    this.contact});

  DeliveryPerson.fromJson(dynamic json) {
    firstName = json["first_name"];
    lastName = json["last_name"];
    contact = json["contact"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["contact"] = contact;
    return map;
  }

}