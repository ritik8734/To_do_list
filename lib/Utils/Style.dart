import 'package:flutter/material.dart';

AppBar appBar(title) => AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: Color(0xFF1DA1F2),
  title: Text(
    title,
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ),
  ),
);
