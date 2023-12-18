import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/admin/screens/posts_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostsScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/amazon_in.png",
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Admin',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () => AccountServices().logOut(context),
                      child: const Text(
                        'LogOut',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        items: [
          // Home
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: _page == 0
                                ? GlobalVariables.selNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth))),
                child: const Icon(Icons.home_outlined),
              )),

          // Analytics
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: _page == 1
                                ? GlobalVariables.selNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth))),
                child: const Icon(Icons.analytics_outlined),
              )),

          // Orders
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: _page == 2
                                ? GlobalVariables.selNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth))),
                child: const Icon(Icons.all_inbox_outlined),
              )),
        ],
      ),
    );
  }
}
