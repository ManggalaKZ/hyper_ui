import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hyper_ui/module/expense_page/add_expense_page.dart';
import 'package:hyper_ui/module/expense_page/expense_detail_page.dart';
import 'package:hyper_ui/module/expense_page/expense_list_page.dart';
import 'package:hyper_ui/module/login_form/view/login_form_view.dart';
import 'package:hyper_ui/module/transaction_page/add_report_page.dart';
import 'package:hyper_ui/module/transaction_page/report_page.dart';
import 'package:hyper_ui/module/transaction_page/report_detail_page.dart';

import 'package:hyper_ui/module/login_form/view/login_form_view.dart';

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
      title: 'Capek Ngoding',
      // navigatorKey: Get.navigatorKey,3
      debugShowCheckedModeBanner: false,
      // theme: getDefaultTheme()

      home: LoginFormView(),
    );
  }
}
