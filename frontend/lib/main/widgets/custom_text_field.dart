import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orana/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.labelText,
    this.textInputType,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.readOnly = false
  });

  final TextEditingController textEditingController;
  final String labelText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: AppColors.primary),
      readOnly: readOnly,
      controller: textEditingController,
      cursorColor: AppColors.secondary,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      maxLines: 4,
      minLines: 1,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.primary),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: 2,
          ),
        ),
        focusColor: AppColors.secondary,
        prefix: prefix,
        suffix: suffix,
      ),
    );
  }
}
