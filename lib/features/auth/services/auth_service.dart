import 'dart:convert';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:amazon_clone/constants/error_handlings.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //sign up user
  void signUpUser(
      {required String email,
      required String password,
      required BuildContext context,
      required String name}) async {
    try {
      User user = User(
          id: "",
          name: name,
          email: email,
          password: password,
          address: "",
          type: "",
          token: "",
          cart: []  
        );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandles(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context,
                "Account created successfully. Login with the same credentials!");
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  //sign in user
  void singInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/signin"), 
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          }
        ), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

      // ignore: use_build_context_synchronously
      httpErrorHandles(
        response: res,
        context: context,
        onSuccess: () async {
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("x-auth-token", json.decode(res.body)['token']);


          Navigator.pushNamedAndRemoveUntil(
              context, MyBottomBar.routeName, (route) => false);
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  //get user data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString("x-auth-token");
      if (token == null) {
        prefs.setString("x-auth-token", '');
      }

      http.Response res = await http.post(Uri.parse("$uri/tokenIsValid"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = json.decode(res.body);

      if (response == true) {
        // get user data
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }
}
