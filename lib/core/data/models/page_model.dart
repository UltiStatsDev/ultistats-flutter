import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/core/domain/entities/page.dart';

part 'page_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageModel<T> extends Page<T> {
  const PageModel({
    required super.content,
    required super.totalElements,
    required super.totalPages,
    required super.currentPage,
    required super.size,
  });

  factory PageModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PageModelToJson(this, toJsonT);
}
