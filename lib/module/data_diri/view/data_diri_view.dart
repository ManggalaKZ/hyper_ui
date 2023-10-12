import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class DataDiriView extends StatefulWidget {
  const DataDiriView({Key? key}) : super(key: key);

  Widget build(context, DataDiriController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data Diri'),
        backgroundColor: Color(0xFF9B51E0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text("Data Diri"),
            SizedBox(
              height: 15,
            ),
            QNumberField(
              label: "KIP Number",
              validator: Validator.required,
              onChanged: (value) {
                controller.kip_number = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QTextField(
              label: "Nama",
              validator: Validator.required,
              onChanged: (value) {
                controller.nama = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QTextField(
              label: "University",
              validator: Validator.required,
              onChanged: (value) {
                controller.university = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QTextField(
              label: "Major",
              validator: Validator.required,
              onChanged: (value) {
                controller.major = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            QTextField(
              label: "Address",
              validator: Validator.required,
              onChanged: (value) {
                controller.address = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Upload Foto Anda",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            QImagePicker(
              label: "Photo",
              validator: Validator.required,
              value: null,
              onChanged: (value) {
                controller.photo = (value);
              },
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF9B51E0))),
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  controller.saveDataDiri(user);
                }
              },
              child: Text('Simpan Data Diri'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<DataDiriView> createState() => DataDiriController();
}
