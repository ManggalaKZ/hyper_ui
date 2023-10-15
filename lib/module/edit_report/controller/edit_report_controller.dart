import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

import '../view/edit_report_view.dart';

class EditReportController extends State<EditReportView> {
  static late EditReportController instance;
  late EditReportView view;

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

  bool cek = false;
  bool cekEdit() {
    return cek;
  }

  DoEditReport() async {
    cek = true;
    FirebaseFirestore.instance.collection('report').doc(view.documentId).get();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Edit Data'),
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
                // Create an empty map to store the fields to update
                Map<String, dynamic> updateData = {};

                // Check each field and add it to the updateData map if it's not empty
                if (reportName.isNotEmpty) {
                  updateData["reportName"] = reportName;
                }
                if (name.isNotEmpty) {
                  updateData["name"] = name;
                }
                if (university.isNotEmpty) {
                  updateData["university"] = university;
                }
                if (major.isNotEmpty) {
                  updateData["major"] = major;
                }
                if (year.isNotEmpty) {
                  updateData["year"] = year;
                }
                if (description.isNotEmpty) {
                  updateData["description"] = description;
                }

                // Check if there's any data to update
                if (updateData.isNotEmpty) {
                  // Update the document with the non-empty fields
                  FirebaseFirestore.instance
                      .collection("report")
                      .doc(view.documentId)
                      .update(updateData);
                  Navigator.pushReplacementNamed(context, '/homeReport');
                } else {
                  // Show a message that no fields are updated
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Info'),
                        content: const SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('No fields are updated.'),
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
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
