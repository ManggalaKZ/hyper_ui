import 'package:flutter/material.dart';

class QTextField extends StatefulWidget {
  final String? id;
  final String label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool enabled;

  final bool isObscured;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;

  const QTextField({
    Key? key,
    required this.label,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.maxLength,
    required this.onChanged,
    this.onSubmitted,
    this.obscure = false,
    this.isObscured = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<QTextField> createState() => _QTextFieldState();
}

class _QTextFieldState extends State<QTextField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.value ?? "";
    super.initState();
  }

  getValue() {
    return textEditingController.text;
  }

  setValue(value) {
    textEditingController.text = value;
  }

  resetValue() {
    textEditingController.text = "";
  }

  focus() {
    focusNode.requestFocus();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: TextFormField(
        enabled: widget.enabled,
        controller: textEditingController,
        focusNode: focusNode,
        cursorColor: Color(0xFF9B51E0),
        validator: widget.validator,
        maxLength: widget.maxLength,
        obscureText: widget.isObscured,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9B51E0))),
          // border:
          //      UnderlineInputBorder(borderSide: BorderSide(none)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9B51E0))),
          labelText: widget.label,
          labelStyle: TextStyle(color: Color(0xFF9B51E0)),
          suffixIcon: Icon(
            widget.suffixIcon ?? Icons.abc,
          ),
          helperText: widget.helper,
          hintText: widget.hint,
        ),
        onChanged: (value) {
          widget.onChanged(value);
        },
        onFieldSubmitted: (value) {
          if (widget.onSubmitted != null) widget.onSubmitted!(value);
        },
      ),
    );
  }
}
