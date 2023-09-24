import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

import '../controller/data_diri_controller.dart';

class DataDiriView extends StatefulWidget {
  const DataDiriView({Key? key}) : super(key: key);

  Widget build(context, DataDiriController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data Diri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: controller.alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              controller: controller.notelpController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            ElevatedButton(
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
