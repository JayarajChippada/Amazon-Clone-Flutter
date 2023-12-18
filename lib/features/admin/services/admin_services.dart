// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handlings.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminSevices {
  void sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required double quantity,
      required String category,
      required List<File> images}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final cloudinary = CloudinaryPublic("dahluqe21", "lrb9gt5d");
      List<String> imageUrls = [];
      List<Future<CloudinaryResponse>> uploadFutures = [];

      for (int i = 0; i < images.length; i++) {
        uploadFutures.add(cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        ));
      }

      // Wait for all Cloudinary uploads to complete
      List<CloudinaryResponse> responses = await Future.wait(uploadFutures);

      // Extract secure URLs from Cloudinary responses
      imageUrls = responses.map((res) => res.secureUrl).toList();

      if (imageUrls.isNotEmpty) {
        // Create the Product instance
        Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price,
        );

        // Send the HTTP request
        http.Response res = await http.post(
          Uri.parse('$uri/admin/add-product'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          },
          body: product.toJson(),
        );

        // Handle the HTTP response
        httpErrorHandles(
          context: context,
          response: res,
          onSuccess: () {
            showSnackBar(context, "Product added successfully!");
            Navigator.pop(context);
          },
        );
      } else {
        // Handle the case where no images were uploaded successfully
        showSnackBar(context, "Failed to upload images to Cloudinary");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );

      httpErrorHandles(
        context: context,
        response: res,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  //delete a product
  void deleteAProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode({"productId": product.id}),
      );

      httpErrorHandles(
        context: context,
        response: res,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get all orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Order> ordersList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );

      httpErrorHandles(
        context: context,
        response: res,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            ordersList.add(
              Order.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return ordersList;
  }

  void changeOrderStatus(
      {required BuildContext context,
      required int status,
      required Order order,
      required VoidCallback onSuccess}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode({"productId": order.id, "status": status}),
      );

      httpErrorHandles(
        context: context,
        response: res,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get all products
  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );

      httpErrorHandles(
        context: context,
        response: res,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales(label: 'Mobiles', earning: response['mobileEarnings']),
            Sales(label: 'Essentials', earning: response['essentialsEarnings']),
            Sales(label: 'Appliances', earning: response['appliancesEarnings']),
            Sales(label: 'Books', earning: response['booksEarnings']),
            Sales(label: 'Fashion', earning: response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      "totalEarnings": totalEarning
    };
  }
}
