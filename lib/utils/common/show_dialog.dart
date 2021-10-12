import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDialog {
  static ShowDialog _instance = new ShowDialog.internal();

  ShowDialog.internal();

  factory ShowDialog() => _instance;

  static void showCustomDialog(BuildContext context, String msg, String btn,
      {VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Platform.isIOS
            ? new CupertinoAlertDialog(
                content: new Text(msg),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        if (okBtnFunction != null) {
                          okBtnFunction();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      isDefaultAction: true,
                      child: Text(
                        btn.isNotEmpty ? btn : "OK",
                      ))
                ],
              )
            : AlertDialog(
                content: Text(msg, textAlign: TextAlign.center),
                actions: [
                    TextButton(
                        onPressed: () {
                          if (okBtnFunction != null) {
                            okBtnFunction();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(btn.isNotEmpty ? btn : "OK"))
                  ]));
  }

  static void showCustomDialogClick(
      BuildContext context, String msg, String btn,
      {VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                content: Text(msg),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        okBtnFunction();
                      },
                      isDefaultAction: true,
                      child: Text(btn.isNotEmpty ? btn : "OK"))
                ],
              )
            : AlertDialog(
                content: Text(msg),
                actions: [
                  TextButton(
                      onPressed: () {
                        okBtnFunction();
                      },
                      child: Text(btn.isNotEmpty ? btn : "OK"))
                ],
              ));
  }
}
