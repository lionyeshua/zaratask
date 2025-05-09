import 'package:equatable/equatable.dart';

// TODO(j): remove equatable?
abstract class Response<T> extends Equatable {
  const Response({required this.successful, this.data, this.message});

  factory Response.error() {
    throw UnimplementedError('Subclasses must implement error');
  }

  factory Response.success() {
    throw UnimplementedError('Subclasses must implement success');
  }

  final bool successful;
  final T? data;
  final String? message;
}
