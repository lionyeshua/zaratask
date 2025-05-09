import 'package:zaratask/core/interfaces/response_model.dart';

class ApiResponse<T> extends Response<T> {
  const ApiResponse._({
    required super.successful,
    this.httpStatusCode,
    super.data,
    super.message,
  });

  factory ApiResponse.success({T? data}) =>
      ApiResponse._(successful: true, httpStatusCode: '200', data: data);

  factory ApiResponse.error({String? httpStatusCode, String? message}) =>
      ApiResponse._(
        successful: false,
        httpStatusCode: httpStatusCode,
        message: message,
      );

  final String? httpStatusCode;

  @override
  List<Object?> get props => [successful, data, message, httpStatusCode];
}
