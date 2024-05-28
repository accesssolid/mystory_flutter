import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(nullable: false)
class CategoryModel {
  String? categoryName;
  String? id;
  String? parentId;

  CategoryModel({this.categoryName, this.id, this.parentId});
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
