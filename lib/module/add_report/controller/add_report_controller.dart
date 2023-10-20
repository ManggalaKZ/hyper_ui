import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class AddReportController extends State<AddReportView> {
  static late AddReportController instance;
  late AddReportView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  String reportName = "";
  String name = "";
  String university = "";
  String major = "";
  String year = "";
  DateTime? date;
  String photo = "";
  String description = "";

  DoAddReport() async {
    if (reportName.isEmpty ||
        name.isEmpty ||
        university.isEmpty ||
        major.isEmpty ||
        year.isEmpty ||
        description.isEmpty ||
        photo.isEmpty) {
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
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Anda yakin untuk menambahkan data?'),
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
                  FirebaseFirestore.instance.collection("report").add({
                    "reportName": reportName,
                    "name": name,
                    "university": university,
                    "major": major,
                    "year": year,
                    "date": DateTime.now(),
                    "photo": photo,
                    "description": description,
                    "user": {
                      "uid": FirebaseAuth.instance.currentUser!.uid,
                      "name": FirebaseAuth.instance.currentUser!.displayName,
                      "email": FirebaseAuth.instance.currentUser!.email
                    }
                  });
                  Navigator.pushReplacementNamed(context, '/homeReport');
                },
                child: Text("Yes"),
              ),
            ],
          );
        },
      );
    }
  }
}
