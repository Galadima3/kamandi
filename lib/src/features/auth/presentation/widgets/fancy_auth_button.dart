import 'package:flutter/material.dart';

class FancyAuthButton extends StatelessWidget {
  final Widget inputW;
  const FancyAuthButton({
    super.key,
    required this.inputW,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        height: 55,
        width: 275,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.blueAccent),
        child: Align(
          alignment: Alignment.center,
          child: inputW,
        ),
      ),
    );
  }
}