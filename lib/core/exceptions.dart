import 'package:dio/dio.dart';

const connectionTimeOut =
    "Connection timed out. Please check your internet connection or try again later.";
const noInternetException =
    "No internet connection available. Please check your network settings and try again.";
const defaultException = "Oops! Something went wrong. Please try again later.";

String handleDioException(DioException dioException) {
  if (dioException.response != null && dioException.response!.data != null) {
    final responseData = dioException.response!.data;
    String? errorMessage = responseData['message'];
    return errorMessage ?? '';
  } else {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return connectionTimeOut;
      case DioExceptionType.connectionError:
        return noInternetException;
      default:
        return defaultException;
    }
  }
}
