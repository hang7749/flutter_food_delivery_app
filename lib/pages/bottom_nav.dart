import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/home.dart';
import 'package:food_delivery_app/pages/order.dart';
import 'package:food_delivery_app/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:food_delivery_app/pages/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

 class _BottomNavState extends State<BottomNav> {

  late List<Widget> pages; // List to hold the pages for each tab
  late Home homePage; // Home page widget
  late Order order;
  late Wallet wallet; // Wallet page widget
  late Profile profile; // Profile page widget
  int currentTabIndex = 0; // Index of the currently selected tab
  
  @override
  void initState() {
    homePage = const Home(); // Initialize the home page
    order = const Order(); // Initialize the order page
    wallet = const Wallet(); // Initialize the wallet page  
    profile = const Profile(); // Initialize the profile page

    pages = [homePage, order, wallet, profile]; // Add pages to the list
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        color: const Color.fromARGB(255, 0, 0, 0), // Set the color of the navigation bar
        buttonBackgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set the button background color
        height: 60, // Set the height of the navigation bar
        animationDuration: const Duration(milliseconds: 500), // Set the animation duration for tab changes
        items: [
          Icon(
            Icons.home_outlined, // Icon for the home tab
            color: Colors.white, // Color of the icon
          ),
          Icon(
            Icons.shopping_bag, // Icon for the order tab
            color: Colors.white, // Color of the icon
          ),
          Icon(
            Icons.wallet_outlined, // Icon for the order tab
            color: Colors.white, // Color of the icon
          ),
          Icon(
            Icons.person_outlined, // Icon for the order tab
            color: Colors.white, // Color of the icon
          ),
        ],
        onTap: (int index) { // Callback when a tab is tapped
          setState(() {
            currentTabIndex = index; // Update the current tab index
          });
        },
      ),
      body: pages[currentTabIndex], // Display the selected page based on the current tab index
    );
  }
}