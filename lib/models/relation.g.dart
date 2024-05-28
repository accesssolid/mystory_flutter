// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationModel _$RelationModelFromJson(Map<String, dynamic> json) {
  return RelationModel(
    relationName: json['relationName'] as String?,
    id: json['id'] as String?,
    createdOnDate: json['createdOnDate'] as int?,
  );
}

Map<String, dynamic> _$RelationModelToJson(RelationModel instance) =>
    <String, dynamic>{
      'relationName': instance.relationName,
      'id': instance.id,
      'createdOnDate': instance.createdOnDate,
    };
