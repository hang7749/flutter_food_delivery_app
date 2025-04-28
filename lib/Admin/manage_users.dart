import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/database.dart';
import 'package:food_delivery_app/services/widget_support.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {

  getontheload() async {
    userStream = await DatabaseMethods().getAllUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Stream? userStream;
  
  late Map<String, dynamic> orderData;

  Widget allUsers() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder:(context, index){
            DocumentSnapshot ds = snapshot.data.docs[index];            
            orderData = ds.data() as Map<String, dynamic>;
            return  Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset("images/boy.jpg", height: 90, width: 90, fit: BoxFit.cover,)),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Color(0xffef2b39),),
                              const SizedBox(width: 10,),
                              Text(
                                ds['name'],
                                style: AppWidget.boldTextFieldStyle(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.email, color: Color(0xffef2b39),),
                              const SizedBox(width: 10,),
                              Text(
                                 ds['email'],
                                style: AppWidget.simpleTextFieldStyle(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () async{
                              await DatabaseMethods().deleteUser(ds["id"]);
                            },
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Remove",
                                  style: AppWidget.whiteTextFieldStyle(),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
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
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                  ),
                  Text(
                    "Current Orders",
                    style: AppWidget.headlineTextFieldStyle(),
                  ),
                ],
              ),
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
                      height: MediaQuery.of(context).size.height / 2,
                      child: allUsers(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}