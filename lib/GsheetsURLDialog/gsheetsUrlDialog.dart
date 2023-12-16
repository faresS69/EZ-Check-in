import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDialog extends StatefulWidget {
  final TextEditingController controller;
  const MyDialog({required this.controller, Key? key}) : super(key: key);

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Google Sheets URL'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Note: the sheet must contain at least 3 columns that includes : 'full name', 'email', 'phone' in column titles. ",
            style: TextStyle(color: Colors.redAccent.shade200),
          ),
          TextField(
            controller: widget.controller,
            decoration: const InputDecoration(hintText: "Google Sheets URL"),
          ),
          // TextField(
          //   controller: _textSheetTitleController,
          //   decoration: const InputDecoration(
          //       hintText: "Worksheet title",
          //       labelText: "Worksheet title"),
          // )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            final gsurlPatterns = [
              "https:",
              "docs.google.com",
              "spreadsheets",
              "d"
            ];
            final urlParts = widget.controller.text.split('/');
            for (String gsurl_pattern in gsurlPatterns) {
              if ((urlParts.length < gsurlPatterns.length + 1) ||
                  (urlParts.contains(gsurl_pattern) == false)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Operation failed!, you must add a valid google sheets url',
                      style: TextStyle(color: Colors.black),
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red[300],
                  ),
                );
                return;
              }
            }
            final spreadsheetId = urlParts[urlParts.indexOf("d") + 1];
            print(urlParts.contains("d"));
            context
                .read<GoogleSheetsProvider>()
                .initializeForWorksheet(
                  spreadsheetId: spreadsheetId,
                )
                .then((value) => {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Spreadsheet URL updated successfully',
                            style: TextStyle(color: Colors.black),
                          ),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.green[300],
                        ),
                      ),
                      Navigator.pop(context)
                    })
                .catchError((e) {
              var errStr = e;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    errStr,
                    style: const TextStyle(color: Colors.black),
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.red[300],
                ),
              );
              print(e);
            });
          },
        ),
      ],
    );
  }
}
