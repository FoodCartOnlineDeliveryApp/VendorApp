import 'package:mealup_restaurant_side/retrofit/server_error.dart';

class BaseModel<T> {
  late ServerError error;
  T? data;


  setException(ServerError error) {
    this.error = error;
  }

  setData(T data) {
    this.data = data;
  }
}

