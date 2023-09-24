import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/akun_cek.dart';

import 'module/button_navigator/button_navigation_bar.dart';
import 'module/login_form/view/login_form_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bijak KIPK',
      routes: {
        '/login': (context) => LoginFormView(),
        '/homeExpense': (context) => FloatMainNavigationView(
              initialSelectedIndex: 1,
            ),
      },
      // navigatorKey: Get.navigatorKey,3
      debugShowCheckedModeBanner: false,
      // theme: getDefaultTheme()

      home: akunCek(),
    );
  }
}
