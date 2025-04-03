import 'package:flutter/material.dart';

import 'Colors.dart';

CustomTextField(_nameController, hintText, {prefix, Icon? suffix}) {
  return TextField(
    controller: _nameController,
    decoration: InputDecoration(
      prefixIcon: prefix,
      suffixIcon: suffix,
      hintStyle: TextStyle(
        color: const Color(0xFF949C9E),
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE5E5E5)),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
