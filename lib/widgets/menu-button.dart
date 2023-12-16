import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MenuButton({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30.0,
      left: 5.0,
      child: IconButton(
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }
}
