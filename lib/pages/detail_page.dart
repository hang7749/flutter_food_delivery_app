import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/services/database.dart';
import 'package:food_delivery_app/services/shared_pref.dart';
import 'package:food_delivery_app/services/widget_support.dart';
//import 'package:food_delivery_app/services/constant.dart';
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
  String? name, id, email, address, wallet;
  Map<String, dynamic>? paymentIntent;

  TextEditingController addresscontoller = TextEditingController();

  getTheSharedPref() async {
    name = await SharedpreferenceHelper().getUserName();
    id = await SharedpreferenceHelper().getUserId();
    email = await SharedpreferenceHelper().getUserEmail();
    address = await SharedpreferenceHelper().getUserAddress();

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
    totalPrice = int.parse(widget.price);
    getUserWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    onTap: () async{
                      if (address == null) {
                        openBox();
                      } else if(int.parse(wallet!) > totalPrice) {
                        int updatedWallet = int.parse(wallet!) - totalPrice;
                        await DatabaseMethods().updateUserWallet(updatedWallet.toString(), id!);

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
                          "Address": address ?? addresscontoller.text,
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
                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Insufficient Wallet Balance",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        );
                      }
                      
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
        ),
      )
    );
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
                    "Enter Address",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("Enter Address"),
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
                  controller: addresscontoller,
                  decoration: InputDecoration(
                    hintText: "Address",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  address = addresscontoller.text;
                  await SharedpreferenceHelper().saveUserAddress(address!);
                  Navigator.pop(context);
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
                        "Enter Address",
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