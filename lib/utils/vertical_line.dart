import 'package:flutter/material.dart';




Widget verticalLine(context, double height) {
  return Container(
    height: height,
    width: 4,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor),
  );
}
