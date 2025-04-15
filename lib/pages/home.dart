import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/category_model.dart';
import 'package:food_delivery_app/model/pizza_model.dart';
import 'package:food_delivery_app/model/burger_model.dart';
import 'package:food_delivery_app/services/category_data.dart';
import 'package:food_delivery_app/services/pizza_data.dart';
import 'package:food_delivery_app/services/burger_data.dart';
import 'package:food_delivery_app/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = [];
  List<PizzaModel> pizza = [];
  List<BurgerModel> burger = [];

  String track = "0"; // Track the index of the selected category


  @override
  void initState() {
    categories = getCategories(); // Fetch the categories from the service
    pizza = getPizza(); // Fetch the pizza from the service
    burger = getBurger(); // Fetch the burger from the service
    // Initialize the track variable to the first category index
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        hintText: "Search for food....",
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
            ),
            const SizedBox(height: 10.0),
            track=="0" ? Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.6, // Adjust the aspect ratio as needed
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: pizza.length,
                  itemBuilder: (context, index) {
                    return FoodTile(
                      pizza[index].name!,
                      pizza[index].image!,
                      "\$${pizza[index].price!}",
                    );
                  },
                ),
              ),
            ) : track=="1" ? Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.6, // Adjust the aspect ratio as needed
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: burger.length,
                  itemBuilder: (context, index) {
                    return FoodTile(
                      burger[index].name!,
                      burger[index].image!,
                      "\$${burger[index].price!}",
                    );
                  },
                ),
              ),
            ) : Container(

            ),
          ],
        ),
      ),
    );
  }

  Widget FoodTile(String name, String image, String price) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),
          Text(name,
            style: AppWidget.boldTextFieldStyle()
          ),
          Text(price,
            style: AppWidget.priceTextFieldStyle()
          ),  
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
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
      child: track==categoryindex ? Container(
        margin: const EdgeInsets.only(right: 20, bottom: 0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
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
          ),
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
