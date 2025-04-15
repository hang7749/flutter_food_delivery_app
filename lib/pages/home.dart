import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/category_model.dart';
import 'package:food_delivery_app/services/category_data.dart';
import 'package:food_delivery_app/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = [];

  String track = "0"; // Track the index of the selected category


  @override
  void initState() {
    categories = getCategories(); // Fetch the categories from the service
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // 👈 Add this
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, top: 40.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/logo.png",
                        height: 50,
                        width: 110,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "Order your favorite food!",
                        style: AppWidget.simpleTextFieldStyle(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/boy.jpg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      margin: const EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for food...",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    //padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return categoryTile(
                      categories[index].name!,
                      categories[index].image!,
                      index.toString(), // Pass the index as a string
                    );
                  },
                ),
              )
            ],
          ),
        ), 
      ),
    );
  }

  Widget categoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        track = categoryindex.toString();
        setState(() {

        }); // Update the state to reflect the selected category
      },
      child: track==categoryindex? Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10.0),
            Text(name,
              style:AppWidget.whiteTextFieldStyle()
            ),
          ],
        ),
      ) : Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10.0),
            Text(name,
              style: AppWidget.simpleTextFieldStyle()
            ),
          ],
      ),
     ),
    );
  }
}
