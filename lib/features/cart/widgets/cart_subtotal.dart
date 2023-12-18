import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubTotal extends StatelessWidget {
  const CartSubTotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart.map(
      (prod) {
        sum += prod['quantity'] * prod['product']['price'] as int; 
      },
    ).toList();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            "SubTotal  ",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "\$$sum",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          )
        ],
      ),
    );
  }
}
