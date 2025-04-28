import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Admin/home_admin.dart';
import 'package:food_delivery_app/services/widget_support.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> { 

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Form(
          //key: _formKey,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                height: MediaQuery.of(context).size.height / 2.3,
                padding: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffffefbf),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "images/pan.png",
                      height: 180,
                      fit: BoxFit.fill,
                      width: 240,
                    ),
                    Image.asset(
                      "images/logo.png",
                      width: 150,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.9,
                    left: 20,
                    right: 20
                ),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height / 2.3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Admin",
                              style: AppWidget.headlineTextFieldStyle(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Username",
                            style: AppWidget.signUpTextFieldStyle(),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              controller: usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your name",
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Password",
                            style: AppWidget.signUpTextFieldStyle(),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your password",
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              loginAdmin();
                            },
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: AppWidget.boldWhiteTextFieldStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()['username'] != usernameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Invalid username",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
          );
        } else if (result.data()['password'] != passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Invalid password",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        }
      }
    });
  }
}