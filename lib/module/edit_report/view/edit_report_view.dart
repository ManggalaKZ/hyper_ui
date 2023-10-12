import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class EditReportView extends StatefulWidget {
  final String documentId;

  EditReportView({required this.documentId});

  Widget build(context, EditReportController controller) {
    controller.view = this;

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('report').doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("Report not found");
        } else {
          var data = snapshot.data?.data() as Map<String, dynamic>;

          var reportName = data['reportName'] ?? 'null';
          var name = data['name'] ?? 'null';
          var university = data['university'] ?? 'null';
          var major = data['major'] ?? 'null';
          var year = data['year'] ?? 'null';
          var description = data['description'] ?? '-';
          var photo = data['photo'] ?? 'null';
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  "Edit Report",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              body: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Report Details",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  QTextField(
                    label: "Report Name",
                    validator: Validator.required,
                    helper: reportName,
                    hint: "Type report name",
                    onChanged: (value) {
                      controller.reportName = (value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  QTextField(
                    label: "Refering Name",
                    validator: Validator.required,
                    helper: name,
                    hint: "Type Refering name",
                    onChanged: (value) {
                      controller.name = (value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  QTextField(
                    label: "University",
                    validator: Validator.required,
                    helper: university,
                    hint: "Select University",
                    onChanged: (value) {
                      controller.university = (value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  QTextField(
                    label: "Major",
                    validator: Validator.required,
                    helper: major,
                    hint: "Type major name",
                    onChanged: (value) {
                      controller.major = (value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  QTextField(
                    label: "Year of Study",
                    validator: Validator.required,
                    helper: year,
                    hint: "Type year of study",
                    onChanged: (value) {
                      controller.year = (value);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    maxLines: 3,
                    validator: Validator.required,
                    decoration: InputDecoration(
                        hintText: "Type description issue",
                        labelText: "Description",
                        labelStyle: TextStyle(color: Color(0xFF9B51E0)),
                        isDense: true,
                        alignLabelWithHint: true,
                        helperText: description),
                    onChanged: (value) {
                      controller.description = (value);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Upload Attachment",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  QImagePicker(
                    label: "Photo",
                    validator: Validator.required,
                    value: photo,
                    onChanged: (value) {
                      controller.photo = (value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9B51E0),
                      ),
                      onPressed: () {
                        controller.DoEditReport();
                        deleteReport(documentId);
                      },
                      child: const Text("Edit Report"),
                    ),
                  ),
                ],
              ));
        }
      },
    );
  }

  void deleteReport(String documentId) {
    // Tambahkan logika penghapusan data berdasarkan documentId
    FirebaseFirestore.instance.collection("report").doc(documentId).delete();
  }

  @override
  State<EditReportView> createState() => EditReportController();
}
