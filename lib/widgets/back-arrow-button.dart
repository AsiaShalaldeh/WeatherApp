import 'package:flutter/material.dart';

class BackArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackArrowButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 0.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
