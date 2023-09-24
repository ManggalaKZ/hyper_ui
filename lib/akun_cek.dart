import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class akunCek extends StatelessWidget {
  final FirebaseAuth _akun = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _akun.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginFormView();
          } else {
            // bool isDataComplete = user
            //     .isDataComplete; // Ganti ini dengan logika sesuai dengan data Anda

            // if (!isDataComplete) {
            return DataDiriView();
            // } else {
            //   return FloatMainNavigationView(
            //     initialSelectedIndex: 0,
            //   );
            // }
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
