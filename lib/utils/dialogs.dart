import 'package:flutter/material.dart';

enum ConfirmAction { cancel, accept }

class Dialogs {
  static Future<ConfirmAction?> confirmDialog(
      BuildContext context,
      final String title,
      final String description,
      final String okAction,
      final String cancelAction) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text(cancelAction,
                  style: const TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.cancel);
              },
            ),
            TextButton(
              child:
                  Text(okAction, style: const TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            )
          ],
        );
      },
    );
  }

  //info dialog with out title
  static Future<ConfirmAction?> infoDialogWithoutTitle(
      BuildContext context, final String description, final String okAction) {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(description),
          // backgroundColor: Color.fromRGBO(1, 64, 81, .8),
          actions: <Widget>[
            TextButton(
              child:
                  Text(okAction, style: Theme.of(context).textTheme.subtitle2),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            )
          ],
        );
      },
    );
  }
}
