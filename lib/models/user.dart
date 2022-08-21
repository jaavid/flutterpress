import 'dart:convert';

UserResponseModel userResponseFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

class UserModel {
  String? userName;
  String? emailId;
  String? password;

  UserModel({
    required this.userName,
    required this.emailId,
    required this.password,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['username'];
    emailId = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.userName;
    data['email'] = this.emailId;
    data['password'] = this.password;
    return data;
  }
}





class UserResponseModel {
  int? code;
  String? message;

  UserResponseModel({this.code, this.message});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}