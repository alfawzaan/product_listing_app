import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_ui/universal_ui.dart';

Widget textClick(String text, Color color, double size,
    {bool withDeco = true, bool withBold = true}) {
  return withDeco
      ? Container(
          margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size),
              color: color,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 4))
              ]),
          child: Align(
              alignment: Alignment.center,
              child: ClipRect(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight:
                            withBold ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
              )))
      : Align(
          alignment: Alignment.center,
          child: ClipRect(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: withBold ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ));
}

Widget customDeco(Widget widget, Color color, double size) {
  return Container(
    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10, top: 5),
    padding: EdgeInsets.only(top: 5, bottom: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: color,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 30,
              spreadRadius: 5,
              offset: Offset(0, 4))
        ]),
    child: widget,
  );
}

double getWidth(BuildContext context, {double ratio: 1}) {
  return MediaQuery.of(context).size.width * ratio;
}

double getHeight(BuildContext context, {double ratio: 1}) {
  return MediaQuery.of(context).size.height * ratio;
}

bool isLargeScreen(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return width > 800; // 1200;
}

bool isSmallScreen(BuildContext context) {
/*
  var size = MediaQuery.of(context).size;
  double width = size.width > size.height ? size.height : size.width;
*/
  var width = MediaQuery.of(context).size.width;
  return width < 800;
}

bool isMediumScreen(BuildContext context) {
/*
  var size = MediaQuery.of(context).size;
  double width = size.width > size.height ? size.height : size.width;
*/
  var width = MediaQuery.of(context).size.width;
  return width > 800 && width < 1200;
}


