import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {this.title, this.colour, required this.onPressed, Key? key})
      : super(key: key);

  final Color? colour;
  final String? title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: colour ?? Colors.black,
      borderRadius: BorderRadius.circular(6.0),
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        minWidth: 200.0,
        height: 50.0,
        child: Text(
          title ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
