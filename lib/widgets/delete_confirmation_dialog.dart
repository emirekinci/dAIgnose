import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';

Future<void> showDeleteConfirmationDialog(
  BuildContext context,
  VoidCallback onConfirm,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_confirmation),
        content: Text(AppLocalizations.of(context)!.delete_confirmation_text),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}
