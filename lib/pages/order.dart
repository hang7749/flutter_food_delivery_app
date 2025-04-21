import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/database.dart';
import 'package:food_delivery_app/services/shared_pref.dart';
import 'package:food_delivery_app/services/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  String? id;
  
  getTheSharedPref() async {
    id = await SharedpreferenceHelper().getUserId();
    setState(() {
      
    });
  }

  getontheload() async {
    await getTheSharedPref();
    ordersStream = await DatabaseMethods().getUserOrders(id!);
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Stream? ordersStream;

  Widget allOrders() {
    return StreamBuilder(
      stream: ordersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder:(context, index){
            DocumentSnapshot ds = snapshot.data.docs[index];
            
            return Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.red, size: 30),
                              Text(
                                "Near Market",
                                style: AppWidget.simpleTextFieldStyle(),
                              )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Image.asset(
                              "images/burger1.png",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cheese Burger",
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.format_list_numbered,
                                      color: Colors.red, size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "4",
                                      style: AppWidget.boldTextFieldStyle(),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.red, size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "\$ 40",
                                      style: AppWidget.boldTextFieldStyle(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Pending!",
                                  style: AppWidget.boldTextFieldStyle().copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );

          }) : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Orders",
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
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: allOrders(),
                  )
                ],
              ),
            ),
          )
        ],)
      ),
    );
  }
}