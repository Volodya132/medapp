import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarForRegister extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  AppBarForRegister({this.title = '', this.actions = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      title: Text(title),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
