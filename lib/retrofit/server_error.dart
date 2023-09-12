import 'package:dio/dio.dart' hide Headers;
import 'package:mealup_restaurant_side/utilities/device_utils.dart';

class ServerError implements Exception {
  int? _errorCode;
  String _errorMessage = "";

  ServerError.withError({error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        _errorMessage = "Connection timeout";
        DeviceUtils.toastMessage('Connection timeout');
        break;
      case DioErrorType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        DeviceUtils.toastMessage('Receive timeout in send request');
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        DeviceUtils.toastMessage('Receive timeout in connection');
        break;
      case DioErrorType.response:
        _errorMessage = "Received invalid status code: ${error.response!.data}";
        try {
          if (error.response!.data['errors']['name'] != null) {
            DeviceUtils.toastMessage(error.response!.data['errors']['name'][0]);
            return;
          } else if (error.response!.data['errors']['phone'] != null) {
            DeviceUtils.toastMessage(error.response!.data['errors']['phone'][0]);
            return;
          } else if (error.response!.data['errors']['email_id'] != null) {
            DeviceUtils.toastMessage(error.response!.data['errors']['email_id'][0]);
            return;
          } else if (error.response!.data['errors']['password'] != null) {
            DeviceUtils.toastMessage(error.response!.data['errors']['password'][0]);
            return;
          } else if (error.response!.data['errors']['vendor_own_driver'] != null) {
            DeviceUtils.toastMessage(error.response!.data['errors']['vendor_own_driver'][0]);
            return;
          } else if (error.response!.data['errors']['phone_code'] != null) {
            DeviceUtils.toastMessage(error.response!.data['errors']['phone_code'][0]);
            return;
          } else {
            DeviceUtils.toastMessage(error.response!.data['message'].toString());
            return;
          }
        } catch (error1, stacktrace) {
          try {
            DeviceUtils.toastMessage(error.response!.data['message'].toString());
          } catch (error11) {
            DeviceUtils.toastMessage(error.response!.data.toString());
          }
          print(
              "Exception occurred: $error stackTrace: $stacktrace apiError: ${error.response!.data}");
        }
        break;
      case DioErrorType.cancel:
        _errorMessage = "Request was cancelled";
        DeviceUtils.toastMessage('Request was cancelled');
        break;
      case DioErrorType.other:
        _errorMessage =
        "Connection failed due to internet connection";
        DeviceUtils.toastMessage('Connection failed due to internet connection');
        break;
    }
    return _errorMessage;
  }
}