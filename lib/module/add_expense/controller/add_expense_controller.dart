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
  DateTime? date;
  num? amount = 0;
  String photo = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> DoAddExpense() async {
    if (nama.isEmpty || category.isEmpty || itemName.isEmpty) {
      _showErrorDialog('Harap lengkapi semua data yang diperlukan.');
    } else if (amount == 0) {
      _showErrorDialog('Harap masukkan amount yang tepat.');
    } else if (date == null) {
      _showErrorDialog('Harap masukkan tanggal.');
    } else {
      User? currentUser = FirebaseAuth.instance.currentUser;
      final expenseQuery = await FirebaseFirestore.instance
          .collection("expense")
          .where("user.uid", isEqualTo: currentUser?.uid)
          .where("name", isEqualTo: nama)
          .where("itemName", isEqualTo: itemName)
          .get();

      if (expenseQuery.docs.isNotEmpty) {
        _showErrorDialog('Pengeluaran dengan nama yang sama sudah ada.');
      } else {
        _showConfirmationDialog();
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Kesalahan'),
          content: Text(message),
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
  }

  void _showConfirmationDialog() {
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
              child: Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                String month = DateFormat('MMMM').format(date!);
                FirebaseFirestore.instance.collection("expense").add({
                  "name": nama,
                  "category": category,
                  "datebaru": date,
                  "date": Timestamp.now(),
                  "bulan": month,
                  "itemName": itemName,
                  "amount": amount,
                  "photo": photo,
                  "user": {
                    "uid": _auth.currentUser!.uid,
                    "name": _auth.currentUser!.displayName,
                    "email": _auth.currentUser!.email
                  }
                });
                Navigator.pushReplacementNamed(context, '/homeExpense');
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
