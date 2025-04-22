import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/services/database.dart';
import 'package:food_delivery_app/services/shared_pref.dart';
import 'package:food_delivery_app/services/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  TextEditingController amountcontoller = new TextEditingController();
  Map<String, dynamic>? paymentIntent;
  String? email, wallet, id;

  getTheSharedPref() async {
    email = await SharedpreferenceHelper().getUserEmail();
    id = await SharedpreferenceHelper().getUserId();
    setState(() {
      
    });
  }

  getUserWallet() async {
    await getTheSharedPref();
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserWalletByEmail(email!);
    wallet = "${querySnapshot.docs[0]['wallet']}";
    setState(() {
      
    });
  }

  @override
  void initState() {
    getUserWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        wallet==null? Center(child: CircularProgressIndicator()): 
       Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Wallet",
                style: AppWidget.headlineTextFieldStyle(),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox (
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(30),
                      //   topRight: Radius.circular(30),
                      // ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/wallet.png",
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Wallet",
                                        style: AppWidget.boldTextFieldStyle()
                                      ),
                                      Text(
                                        "\$ $wallet",
                                        style: AppWidget.headlineTextFieldStyle()
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  makePayment("50");
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "\$ 50",
                                      style: AppWidget.priceTextFieldStyle(),
                                    ),
                                  )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  makePayment("100");
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "\$ 100",
                                      style: AppWidget.priceTextFieldStyle(),
                                    ),
                                  )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  makePayment("200");
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "\$ 200",
                                      style: AppWidget.priceTextFieldStyle(),
                                    ),
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async{
                            openBox();
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color(0xffef2b39),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Add Money",
                                style: AppWidget.boldWhiteTextFieldStyle(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              
                ],
              ),
            ),
          )
        ],)
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      // 1. Create payment intent
      paymentIntent = await createPaymentIntent(amount, 'USD');
      

      print("Payment Intent: $paymentIntent");

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Food Delivery App',
          // customerId: paymentIntent!['customer'],
          // customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
        ),
      );
      
      // 3. Display the payment sheet
      displayPaymentSheet(amount);
      
    } catch (e, s) {
      print('Payment error: $e\n$s');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async{
        int updatedWallet = int.parse(wallet!) + int.parse(amount);
        await DatabaseMethods().updateUserWallet(updatedWallet.toString(), id!);
        await getUserWallet();

        showDialog(
          context: context, 
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Icon(
                    Icons.check_circle, 
                    color: Colors.green
                  ),
                  Text('Payment Successful'),
                ],
  
                )
              ],
            ),
          ));

          paymentIntent = null;

      }).onError((error, stackTrace) {
        //print("Error is : ---> $error $stackTrace");
      });
    } on StripeException catch (e) {
      //print('Error displaying payment sheet: ${e.error}');
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          content: Text("Cancelled"),
      ));
    } catch (e) {
      //print('Error displaying payment sheet: $e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {

      String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      //print('Error creating payment intent: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);

    return calculatedAmount.toString();
  }

  Future openBox() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Add Amount",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("Enter Amount"),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black38,
                    width: 2
                  ),
                ),
                child: TextField(
                  controller: amountcontoller,
                  decoration: InputDecoration(
                    hintText: "Amount",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  makePayment(amountcontoller.text);
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Add Amount",
                        style: AppWidget.boldWhiteTextFieldStyle(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}