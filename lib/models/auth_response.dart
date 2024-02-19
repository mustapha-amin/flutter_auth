import 'dart:convert';

class AuthResponse {
  Data? data;
  String? message;
  int? statusCode;
  bool? success;

  AuthResponse({
    this.data,
    this.message,
    this.statusCode,
    this.success,
  });

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        statusCode: json["statusCode"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
        "statusCode": statusCode,
        "success": success,
      };
}

class Data {
  String? accessToken;
  String? refreshToken;
  User? user;

  Data({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"] ?? "",
        refreshToken: json["refreshToken"] ?? "",
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "user": user?.toJson(),
      };
}

class User {
  int? v;
  String? id;
  Avatar? avatar;
  DateTime? createdAt;
  String? email;
  bool? isEmailVerified;
  String? loginType;
  String? role;
  DateTime? updatedAt;
  String? username;

  User({
    this.v,
    this.id,
    this.avatar,
    this.createdAt,
    this.email,
    this.isEmailVerified,
    this.loginType,
    this.role,
    this.updatedAt,
    this.username,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        v: json["__v"],
        id: json["_id"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        email: json["email"],
        isEmailVerified: json["isEmailVerified"],
        loginType: json["loginType"],
        role: json["role"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "__v": v,
        "_id": id,
        "avatar": avatar?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "email": email,
        "isEmailVerified": isEmailVerified,
        "loginType": loginType,
        "role": role,
        "updatedAt": updatedAt?.toIso8601String(),
        "username": username,
      };
}

class Avatar {
  String? id;
  String? localPath;
  String? url;

  Avatar({
    this.id,
    this.localPath,
    this.url,
  });

  factory Avatar.fromRawJson(String str) => Avatar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json["_id"] ?? "",
        localPath: json["localPath"] ?? "",
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "localPath": localPath,
        "url": url,
      };
}
