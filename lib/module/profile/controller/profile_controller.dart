import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

import '../view/profile_view.dart';

class ProfileController extends State<ProfileView> {
  static late ProfileController instance;
  late ProfileView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  Dologout() {
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
                Text('Apakah ingin Logout?'),
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
                backgroundColor: Color(0xFF9B51E0),
              ),
              onPressed: () {
                confirm = true;
                Confirmlogout();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (confirm) {
      print("Confirmed!");
    }
  }

  Confirmlogout() {
    try {
      FirebaseAuth.instance.signOut();
      // Redirect ke halaman login atau halaman awal aplikasi setelah logout berhasil.
      Navigator.pushReplacementNamed(
          context, '/login'); // Gantilah '/login' dengan rute yang sesuai.
    } catch (e) {
      print("Error saat logout: $e");
    }
    Navigator.pushReplacementNamed(context, '/login');
  }
}
