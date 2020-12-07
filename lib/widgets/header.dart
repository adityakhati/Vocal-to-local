import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false,
    String titleText,
    bool removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? 'Local to Vocal' : titleText,
      style: TextStyle(
          color: Colors.white,
          fontFamily: isAppTitle ? 'Signatra' : "",
          fontSize: isAppTitle ? 50.0 : 22.0),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
