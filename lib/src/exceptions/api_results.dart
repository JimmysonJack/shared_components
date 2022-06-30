import 'package:freezed_annotation/freezed_annotation.dart';
import 'network_exceptions.dart';
part 'api_results.freezed.dart';
@freezed
class ApiResults<T> with _$ApiResults<T> {
  const factory ApiResults.success({required T data}) = Success<T>;
  const factory ApiResults.failure({required NetworkExceptions error}) = Failure<T>;
}