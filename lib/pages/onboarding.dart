import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // 👈 Add this
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            children: [
              Image.asset(
                "images/onboard.png",
              ),
              const SizedBox(height: 20.0), // Add some space between the image and the text
              Text(
                "The Fastest Food Delivery App",
                textAlign: TextAlign.center,
                style: AppWidget.headlineTextFieldStyle()
              ),
              const SizedBox(height: 20.0), // Add some space between the title and the subtitle
              Text("Come order Now and deliver your food to your home",
                textAlign: TextAlign.center,
                style: AppWidget.simpleTextFieldStyle()
              ),
              const SizedBox(height: 30.0), // Add some space between the subtitle and the button
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Get Started",
                    style: AppWidget.simpleTextFieldStyle().copyWith(color: Colors.white)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
