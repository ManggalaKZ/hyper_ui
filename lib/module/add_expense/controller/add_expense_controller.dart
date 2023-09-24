import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class AddExpenseController extends State<AddExpensePageView> {
  static late AddExpenseController instance;
  late AddExpensePageView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  String nama = "";
  String category = "";
  String itemName = "";
  String date = "";
  num? amount = 0;
  String photo = "";

  DoAddExpense() async {
    if (nama.isEmpty || category.isEmpty || itemName.isEmpty || photo.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Kesalahan'),
            content: Text('Harap lengkapi semua data yang diperlukan.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (amount == 10) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Kesalahan'),
            content: Text('Harap masukkan jumlah yang valid.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      await FirebaseFirestore.instance.collection("expense").add({
        "name": nama,
        "category": category,
        "datebaru": date,
        "itemName": itemName,
        "amount": amount,
        "photo": photo,
        "user": {
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "name": FirebaseAuth.instance.currentUser!.displayName,
          "email": FirebaseAuth.instance.currentUser!.email
        }
      });
    }
  }

  ConfirmAdd() {
    bool confirm = false;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tambahkan Data'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9B51E0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                DoAddExpense();
                Navigator.pushReplacementNamed(context, '/homeExpense');
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void goBack() {
    // Go back to the previous page
    Get.back();
  }
}
