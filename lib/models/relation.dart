import 'package:json_annotation/json_annotation.dart';

part 'relation.g.dart';

@JsonSerializable()
class RelationModel {
  String? relationName;
  String? id;
  int? createdOnDate;
 

  RelationModel({this.relationName, this.id, this.createdOnDate});


  factory RelationModel.fromJson(Map<String, dynamic> json) =>
      _$RelationModelFromJson(json);
  Map<String, dynamic> toJson() => _$RelationModelToJson(this);
}
