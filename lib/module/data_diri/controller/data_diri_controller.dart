import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import '../view/data_diri_view.dart';

class DataDiriController extends State<DataDiriView> {
  static late DataDiriController instance;
  late DataDiriView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController notelpController = TextEditingController();

  void saveDataDiri(User user) {
    FirebaseFirestore.instance.collection('datadiri').doc(user.uid).set({
      'password': passwordController.text,
      'alamat': alamatController.text,
      'notelp': notelpController.text,
    }).then((_) {
      print('Data diri disimpan');
    }).catchError((error) {
      print('Error saat menyimpan data diri: $error');
    });
  }
}
