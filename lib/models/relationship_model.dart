class RelationShipModel {
  final bool? isSuccess;
  final List<Data>? data;
  final bool? isServerError;
  final String? message;

  RelationShipModel({
    this.isSuccess,
    this.data,
    this.isServerError,
    this.message,
  });

  RelationShipModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'] as bool?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList(),
        isServerError = json['isServerError'] as bool?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'isSuccess' : isSuccess,
    'data' : data?.map((e) => e.toJson()).toList(),
    'isServerError' : isServerError,
    'message' : message
  };
}

class Data {
  final int? createdOnDate;
  final String? middleName;
  final String? id;
  final String? lastName;
  final String? firstName;
  final Address? address;
  final String? email;
  final String? dob;
  final String? profilePicture;
  final Relation? relation;
  final String? treeAdminId;

  Data({
    this.createdOnDate,
    this.middleName,
    this.id,
    this.lastName,
    this.firstName,
    this.address,
    this.email,
    this.dob,
    this.profilePicture,
    this.relation,
    this.treeAdminId,
  });

  Data.fromJson(Map<String, dynamic> json)
      : createdOnDate = json['createdOnDate'] as int?,
        middleName = json['middleName'] as String?,
        id = json['id'] as String?,
        lastName = json['lastName'] as String?,
        firstName = json['firstName'] as String?,
        address = (json['address'] as Map<String,dynamic>?) != null ? Address.fromJson(json['address'] as Map<String,dynamic>) : null,
        email = json['email'] as String?,
        dob = json['dob'] as String?,
        profilePicture = json['profilePicture'] as String?,
        relation = (json['relation'] as Map<String,dynamic>?) != null ? Relation.fromJson(json['relation'] as Map<String,dynamic>) : null,
        treeAdminId = json['treeAdminId'] as String?;

  Map<String, dynamic> toJson() => {
    'createdOnDate' : createdOnDate,
    'middleName' : middleName,
    'id' : id,
    'lastName' : lastName,
    'firstName' : firstName,
    'address' : address?.toJson(),
    'email' : email,
    'dob' : dob,
    'profilePicture' : profilePicture,
    'relation' : relation?.toJson(),
    'treeAdminId' : treeAdminId
  };
}

class Address {
  final String? countryValue;
  final String? cityValue;
  final String? stateValue;

  Address({
    this.countryValue,
    this.cityValue,
    this.stateValue,
  });

  Address.fromJson(Map<String, dynamic> json)
      : countryValue = json['countryValue'] as String?,
        cityValue = json['cityValue'] as String?,
        stateValue = json['stateValue'] as String?;

  Map<String, dynamic> toJson() => {
    'countryValue' : countryValue,
    'cityValue' : cityValue,
    'stateValue' : stateValue
  };
}

class Relation {
  final String? id;
  final String? relationName;

  Relation({
    this.id,
    this.relationName,
  });

  Relation.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        relationName = json['relationName'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'relationName' : relationName
  };
}


//
// To parse this JSON data, do
//
//     final relationShipModel = relationShipModelFromJson(jsonString);

// import 'dart:convert';
//
// RelationShipModel relationShipModelFromJson(String str) => RelationShipModel.fromJson(json.decode(str));
//
// String relationShipModelToJson(RelationShipModel data) => json.encode(data.toJson());
//
// class RelationShipModel {
//   RelationShipModel({
//   required  this.isSuccess,
//     required  this.data,
//     required this.isServerError,
//     required this.message,
//   });
//
//   bool isSuccess;
//   List<Datum> data;
//   bool isServerError;
//   String message;
//
//   factory RelationShipModel.fromJson(Map<String, dynamic> json) => RelationShipModel(
//     isSuccess: json["isSuccess"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     isServerError: json["isServerError"],
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "isSuccess": isSuccess,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     "isServerError": isServerError,
//     "message": message,
//   };
// }
//
// class Datum {
//   Datum({
//     required this.createdOnDate,
//     required this.middleName,
//     required this.id,
//     required this.lastName,
//     required this.firstName,
//     required this.address,
//     required this.email,
//     required this.dob,
//     required this.profilePicture,
//     required this.relation,
//     required this.treeAdminId,
//   });
//
//   int createdOnDate;
//   String middleName;
//   String id;
//   String lastName;
//   String firstName;
//   Address address;
//   String email;
//   String dob;
//   String profilePicture;
//   Relation relation;
//   String treeAdminId;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     createdOnDate: json["createdOnDate"],
//     middleName: json["middleName"],
//     id: json["id"],
//     lastName: json["lastName"],
//     firstName: json["firstName"],
//     address: Address.fromJson(json["address"]),
//     email: json["email"],
//     dob: json["dob"],
//     profilePicture: json["profilePicture"],
//     relation: Relation.fromJson(json["relation"]),
//     treeAdminId: json["treeAdminId"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "createdOnDate": createdOnDate,
//     "middleName": middleName,
//     "id": id,
//     "lastName": lastName,
//     "firstName": firstName,
//     "address": address.toJson(),
//     "email": email,
//     "dob": dob,
//     "profilePicture": profilePicture,
//     "relation": relation.toJson(),
//     "treeAdminId": treeAdminId,
//   };
// }
//
// class Address {
//   Address({
//     required this.countryValue,
//     required this.cityValue,
//     required this.stateValue,
//   });
//
//   String countryValue;
//   String cityValue;
//   String stateValue;
//
//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//     countryValue: json["countryValue"],
//     cityValue: json["cityValue"],
//     stateValue: json["stateValue"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "countryValue": countryValue,
//     "cityValue": cityValue,
//     "stateValue": stateValue,
//   };
// }
//
// class Relation {
//   Relation({
//     required this.id,
//     required this.relationName,
//   });
//
//   String id;
//   String relationName;
//
//   factory Relation.fromJson(Map<String, dynamic> json) => Relation(
//     id: json["id"],
//     relationName: json["relationName"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "relationName": relationName,
//   };
// }
