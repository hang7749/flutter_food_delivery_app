import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set(userInfoMap);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future addUserOrderDetails(Map<String, dynamic> userOrderMap, String id, String orderId) async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(id).collection("Orders").doc(orderId)
          .set(userOrderMap);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future addAdminOrderDetails(Map<String, dynamic> userOrderMap, String orderId) async {
    try {
      return await FirebaseFirestore.instance
          .collection("Orders").doc(orderId)
          .set(userOrderMap);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<Stream<QuerySnapshot>> getUserOrders(String id) async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("Orders")
          .snapshots();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      throw Exception("Failed to fetch user orders: $e");
    }
  }
}