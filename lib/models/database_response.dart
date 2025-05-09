import 'package:zaratask/core/interfaces/response_model.dart';

class DatabaseResponse<T> extends Response<T> {
  const DatabaseResponse._({
    required super.successful,
    super.data,
    super.message,
  });

  factory DatabaseResponse.success({T? data}) =>
      DatabaseResponse._(successful: true, data: data);

  factory DatabaseResponse.error({String? message}) =>
      DatabaseResponse._(successful: false, message: message);

  @override
  List<Object?> get props => [successful, data, message];
}
