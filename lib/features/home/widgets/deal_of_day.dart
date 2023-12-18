import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DealofDay extends StatefulWidget {
  const DealofDay({super.key});

  @override
  State<DealofDay> createState() => _DealofDayState();
}

class _DealofDayState extends State<DealofDay> {
  final HomeServices homeServices = HomeServices();
  Product? product;

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    try {
      product = await homeServices.fetchDealOfDay(context: context);
      setState(() {
        
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void navigateToProductDetailsScreen() {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
        arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return product == null
        ? const Loader()
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
              onTap: navigateToProductDetailsScreen,
              child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 15, left: 20),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Image.network(
                      product!.images[0],
                      height: 255,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        '\$${product!.price}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: Text(
                        user.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product!.images
                            .map(
                              (i) => Image.network(
                                i,
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15)
                          .copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "See all deals",
                        style: TextStyle(color: Colors.cyan[800]),
                      ),
                    )
                  ],
                ),
            );
  }
}
