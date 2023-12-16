import 'dart:core';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NeumorphismButton extends StatefulWidget {
  List<dynamic> uncompletedTodos;
  List<dynamic> completedTodos;
  NeumorphismButton(
      {super.key,
      required this.uncompletedTodos,
      required this.completedTodos});

  @override
  State<NeumorphismButton> createState() => _NeumorphismButtonState();
}

class _NeumorphismButtonState extends State<NeumorphismButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      height: 500.0,
      color: const Color(0xff333333),
      alignment: Alignment.center,
      transformAlignment: Alignment.center,
      child: Container(
        color: const Color(0xff333333),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xff333333),
            borderRadius: BorderRadius.circular(57),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff444444),
                Color(0xff222222),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xff444444),
                offset: Offset(-13.7, -13.7),
                blurRadius: 54,
                spreadRadius: 0.0,
              ),
              BoxShadow(
                color: Color(0xff222222),
                offset: Offset(13.7, 13.7),
                blurRadius: 54,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: const Icon(
            Icons.star,
            size: 67,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
