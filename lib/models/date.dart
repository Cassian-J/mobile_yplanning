import 'package:freezed_annotation/freezed_annotation.dart';

part 'date.freezed.dart';
part 'date.g.dart';

@freezed
class Date with _$Date {
  const factory Date({
    required int id,
    required String title,
    required String body,
    required int dateBegin,
    required int dateEnd,
    required bool private,
  }) = _Date;

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);
}