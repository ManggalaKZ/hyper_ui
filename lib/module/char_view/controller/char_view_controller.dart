import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import '../view/char_view_view.dart';

class CharViewController extends State<CharViewView> {
  static late CharViewController instance;
  late CharViewView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
