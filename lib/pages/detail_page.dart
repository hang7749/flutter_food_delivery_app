import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/services/database.dart';
import 'package:food_delivery_app/services/shared_pref.dart';
import 'package:food_delivery_app/services/widget_support.dart';
import 'package:food_delivery_app/services/constant.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {

  String image;
  String name;
  String price;

  DetailPage({required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int quantity = 1;
  int totalPrice = 0;
  String? name, id, email ;
  Map<String, dynamic>? paymentIntent;

  getTheSharedPref() async {
    name = await SharedpreferenceHelper().getUserName();
    id = await SharedpreferenceHelper().getUserId();
    email = await SharedpreferenceHelper().getUserEmail();

    setState(() {
      
    });
  }

  @override
  void initState() {
    totalPrice = int.parse(widget.price);
    getTheSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.arrow_back, 
                  color: Colors.white, 
                  size: 30
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                widget.image, 
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.name, 
              style: AppWidget.headlineTextFieldStyle()
            ),
            Text("\$${widget.price}", 
              style: AppWidget.priceTextFieldStyle()
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: AppWidget.simpleTextFieldStyle(),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Quantity",
              style: AppWidget.simpleTextFieldStyle(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {

                    setState(() {
                      if (quantity < 10) {
                        quantity = quantity + 1;
                        totalPrice = totalPrice + int.parse(widget.price);
                      }
                    });
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add, 
                        color: Colors.white, 
                        size: 30
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "1",
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity = quantity - 1;
                        totalPrice = int.parse(widget.price) * quantity;
                      }
                    });
                 
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.remove, 
                        color: Colors.white, 
                        size: 30
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 70,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "\$ $totalPrice",
                        style: AppWidget.boldWhiteTextFieldStyle(),
                      ),
                    )
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    makePayment(totalPrice.toString());
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Order Now",
                          style: AppWidget.whiteTextFieldStyle(),
                        ),
                      )
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  // Future<void> makePayment(String amount) async {
  //   try {
  //     paymentIntent = await createPaymentIntent(amount, 'USD');
  //     await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
  //       paymentIntentClientSecret: paymentIntent?['client_secret'],
  //       style: ThemeMode.dark,
  //       merchantDisplayName: 'Admin'))
  //     .then((value) => {});

  //   } catch (e, s) {
  //     print('Error creating payment intent: $e$s');
  //   }
  // }

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

        String orderId = randomAlphaNumeric(10);

        Map<String, dynamic> userOrderMap = {
          "Name": name,
          "Id": id,
          "Quantity": quantity.toString(),
          "Total": totalPrice.toString(),
          "Email": email,
          "FoodName": widget.name,
          "FoodImage": widget.image,
          "OrderId": orderId,
          "Status": "Pending",
        };

        await DatabaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
        await DatabaseMethods().addAdminOrderDetails(userOrderMap, orderId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Order Placed Successfully",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 4),
          )
        );

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
        print("Error is : ---> $error $stackTrace");
      });
    } on StripeException catch (e) {
      print('Error displaying payment sheet: ${e.error}');
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          content: Text("Cancelled"),
      ));
    } catch (e) {
      print('Error displaying payment sheet: $e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
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
      print('Error creating payment intent: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);

    return calculatedAmount.toString();
  }
  

}