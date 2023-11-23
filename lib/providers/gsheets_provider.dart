import 'dart:convert';

import 'package:ez_check_in/classes/attendee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:provider/provider.dart';

class GoogleSheetsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late GSheets _gsheets;

  late Worksheet _worksheet;
  late Map<String, int> _sheetKeys = new Map<String, int>();
  List<Attendee> _attendees = List<Attendee>.empty();
  List<Attendee> get attendees => _attendees;
  GoogleSheetsProvider(
      String credentials_path, String spreadsheetId, String worksheetTitle) {
    initializeForWorksheet(
            credentials_path: credentials_path,
            spreadsheetId: spreadsheetId,
            worksheetTitle: worksheetTitle)
        .then((value) => print("worksheet initialized"))
        .catchError((onError) {
      print(onError);
    });
  }
  Future<void> initializeForWorksheet(
      {String credentials_path = "assets/credentials.json",
      String spreadsheetId = "1lzZvXZ3-Sb2vDSLPZf9Rgo5bQtKCoTHu0EUwCdBNeQU",
      String worksheetTitle = "Sheet1"}) async {
    String credentialsJson =
        await rootBundle.loadString('assets/credentials.json');
    _gsheets = GSheets(jsonDecode(credentialsJson));
    final excel = await _gsheets.spreadsheet(spreadsheetId);

    _worksheet = excel.worksheetByTitle(worksheetTitle)!;
    var keys = (await _worksheet.values.row(1));
    keys.forEach((r) => this._sheetKeys[r.toLowerCase()] = keys.indexOf(r));
    await getAttendees();
  }

  Future<void> getAttendees() async {
    print(_sheetKeys);

    /// skips the first value which is the header
    final values = (await _worksheet.values.allRows()).skip(1).toList();

    _attendees = values.map((value) => Attendee.fromSheets(value)).toList();
    notifyListeners();
  }

  Future<bool> checkInAttendee(String value,
      {String column = "check-in"}) async {
    print(_worksheet);
    if (_worksheet == null) {
      print("worksheet is null");
      return false;
    }
    print(_worksheet);
    // print(value == (await _worksheet.values.row(2))[0]);

    var rowIndex = await _worksheet.values.rowIndexOf(value, inColumn: 1);
    print(rowIndex);
    if (rowIndex == -1) {
      return false;
    }
    print(_sheetKeys);
    // int colIndex = 3;
    int colIndex = _sheetKeys["check-in"] as int;
    if ((await _worksheet.values.row(rowIndex))[colIndex] == "TRUE") {
      return true;
    }
    var result =
        await _worksheet.values.insertColumn(4, ["TRUE"], fromRow: rowIndex);
    notifyListeners();
    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Attendee>("attendees", attendees));
    // properties.add(ListPr('count', attendees));
  }
}
