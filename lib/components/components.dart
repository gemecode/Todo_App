import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,

  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTap,

  enabled: isClickable ,

  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
        prefix
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: ()
      {
        suffixPressed!();
      },
      icon: Icon(
          suffix
      ),
    ) : null,
    border: const OutlineInputBorder(),
  ),
);
