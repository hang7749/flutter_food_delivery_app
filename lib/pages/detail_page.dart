import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/widget_support.dart';

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

  @override
  void initState() {
    totalPrice = int.parse(widget.price);
    print("Total Price: $totalPrice");
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
            Text(widget.price, 
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
                Material(
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
                )
              ],
            )
          ],
        ),
      )
    );
  }
}