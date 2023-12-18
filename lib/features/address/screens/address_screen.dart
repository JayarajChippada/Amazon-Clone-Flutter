import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_sevices.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();

  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = '';

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price));
  }

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void navigateToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalPrice: double.parse(widget.totalAmount));
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController} - ${pincodeController}';
      } else {
        throw Exception('Please enter all values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    if (address.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black12,
                            )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                address,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "OR",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        hintText: 'Flat, House no., Building',
                        controller: flatBuildingController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        hintText: 'Area, Street', controller: areaController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        hintText: 'Pincode', controller: pincodeController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        hintText: 'Town/City', controller: cityController),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              FutureBuilder<PaymentConfiguration>(
                  future: PaymentConfiguration.fromAsset(
                      'gpay.json'),
                  builder: (context, snapshot) => snapshot.hasData
                      ? GooglePayButton(
                          paymentConfiguration: snapshot.data!,
                          paymentItems: paymentItems,
                          type: GooglePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onGooglePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
