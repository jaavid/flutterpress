import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kermaneno/config/wp_config.dart';
import '../models/user.dart';

class AuthService {
  static var client = http.Client();

  static Future<UserModel?> loginWithEmail(
      String userName, String password) async {
    Map<String, String> _requestHeader = {
      'Content-type': 'application/x-www-form-urlencoded',
    };

    var response = await client.post(
        Uri.parse("${WpConfig.websiteUrl}/wp-json/jwt-auth/v1/token"),
        headers: _requestHeader,
        body: {"username": userName, "password": password});
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      debugPrint(decoded['token']);
      UserModel userModel = UserModel(
          userName: decoded['user_display_name'],
          emailId: decoded['user_email'],
          password: password);

      return userModel;
    } else {
      return null;
    }
  }

  static Future<UserResponseModel> createUser(UserModel model) async {
    Map<String, String> _requestHeader = {'Content-type': 'application/json'};

    var response = await client.post(
      Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/users/register"),
      headers: _requestHeader,
      body: jsonEncode(model.toJson()),
    );

    return userResponseFromJson(response.body);
  }
}
