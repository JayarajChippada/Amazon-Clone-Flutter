import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/order_details/screens/order_details.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AdminSevices adminSevices = AdminSevices();

  List<Order>? orders;
  @override
  void initState() {
    fetchAllOrders();
    super.initState();
  }

  void fetchAllOrders() async {
    orders = await adminSevices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final orderData = orders![index];
              return SizedBox(
                height: 140,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      OrderDetailsScreen.routeName,
                      arguments: orderData
                    );
                  },
                  child: SingleProduct(
                    image: orderData.products[0].images[0],
                  ),
                ),
              );
            },
          );
  }
}
