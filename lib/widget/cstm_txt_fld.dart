import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.fillColor = Colors.white,
    this.style,
    this.inputFormatters,
    this.hintext,
    this.suffixIcon,
    this.isObsecure = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.height,
    this.borderRadius,
    this.enabled = true,
    this.isRead = false

  }) : super(key: key);

  final String? hintext;
  final IconButton? suffixIcon;
  final bool isObsecure;
  final bool enabled;
  final double? height;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  final dynamic validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final dynamic onChanged;
  final bool? isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: isObsecure,readOnly: isRead ?? false,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: style,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          hintText: hintext,
          hintStyle: TextStyle(
            color: Colors.grey.shade400
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
