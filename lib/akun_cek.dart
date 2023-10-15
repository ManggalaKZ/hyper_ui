import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class akunCek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List<DocumentSnapshot>> getdata() async {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
            .collection("datadiri")
            .where("user.uid", isEqualTo: currentUserId)
            .get();

        return expenseSnapshot.docs;
      } else {
        return [];
      }
    }

    final FirebaseAuth _akun = FirebaseAuth.instance;

    return StreamBuilder(
      stream: _akun.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            return LoginFormView();
          } else {
            return FutureBuilder<List<DocumentSnapshot>>(
              future: getdata(),
              builder: (context, dataDiriSnapshot) {
                if (dataDiriSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                } else if (dataDiriSnapshot.hasError) {
                  return Text("Error: ${dataDiriSnapshot.error}");
                } else if (!dataDiriSnapshot.hasData ||
                    !dataDiriSnapshot.hasData ||
                    dataDiriSnapshot.data!.isEmpty) {
                  return DataDiriView();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FloatMainNavigationView(
                              initialSelectedIndex: 0,
                            )),
                  );
                  return CircularProgressIndicator();
                }
              },
            );
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
