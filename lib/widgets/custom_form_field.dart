import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.hintText = "",
    this.boxColor = Colors.white,
    this.textColor = Colors.white,
    this.textInputType = TextInputType.text,
    this.maxLength = 32,
    this.validator,
    this.controller,
  });

  final String hintText;
  final Color boxColor;
  final Color textColor;
  final TextInputType textInputType;
  final int maxLength;
  final FormFieldValidator? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        autocorrect: false,
        enableSuggestions: false,
        inputFormatters: [
          if (textInputType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly
          else if (textInputType == TextInputType.name)
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
          else if (textInputType == TextInputType.emailAddress)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._%+\-]'))
          else if (textInputType == TextInputType.text)
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
          else if (textInputType == TextInputType.url)
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z0-9:/?&=._\-#%]+'),
            )
          else if (textInputType == TextInputType.visiblePassword)
            FilteringTextInputFormatter.allow(
              RegExp(
                r'[a-zA-Z0-9!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:\",\.<>\/\?\\|`~]',
              ),
            ),
        ],
        obscureText: textInputType == TextInputType.visiblePassword,
        keyboardType: textInputType,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 0.0),
          hintText: hintText,
          hintStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ),
          counterText: "",
        ),
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontSize: 16.0),
        maxLines: 1,
      ),
    );
  }
}
