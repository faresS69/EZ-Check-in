import 'dart:convert';
import 'dart:math';

import 'package:exponential_back_off/exponential_back_off.dart';
import 'package:ez_check_in/classes/attendee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

var formURL = "1p0sCeshZflXviQqwPL8SizVX3_WqahhUQ6NUKFfcT0Y";
final exponentialBackOff =
    ExponentialBackOff(maxElapsedTime: Duration(seconds: 15), maxAttempts: 200);

class GoogleSheetsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late GSheets _gsheets;

  late Worksheet _worksheet;
  late Map<String, int> _sheetKeys = <String, int>{};
  String? _worksheetTitle;
  String _spreadsheetID = "";
  List<Attendee> _attendees = List<Attendee>.empty();
  List<Attendee> get attendees => _attendees;
  int _randCred = Random.secure().nextInt(4294967296) % 20 + 1;
  GoogleSheetsProvider(
    String credentials_path, {
    String? spreadsheetId,
    String? worksheetTitle,
  }) {
    initializeForWorksheet(
            // credentials_path: credentials_path,
            spreadsheetId: spreadsheetId,
            worksheetTitle: worksheetTitle)
        .then((value) => print("worksheet initialized"))
        .catchError((onError) {
      print(onError);
    });
  }
  // Future<AutoRefreshingAuthClient> getAuthClient(String accessToken) async {

  //   return await clientViaUserConsentManual(clientId, scopes, (url) async {
  //     print("Please go to the following URL and grant access:");
  //     print("  => $url");
  //     return "full";
  //   });
  // clientViaApplicationDefaultCredentials(scopes: scopes)
  // return clientViaApiKey("") as AutoRefreshingAuthClient;
  // }

  void setRandCred(int randCred) async {
    _randCred = randCred;
    await initializeForWorksheet(random: false);
  }

  Future<void> initializeForWorksheet({
    String? worksheetTitle,
    String? spreadsheetId,
    bool random = true,
    String credentials_path = "assets/keys/credential",
  }) async {
    if (random) _randCred = Random.secure().nextInt(4294967296) % 20 + 1;
    String credentialsJson =
        await rootBundle.loadString("$credentials_path$_randCred.json");
    _gsheets = GSheets(jsonDecode(credentialsJson));
    print("$credentials_path$_randCred.json wowow");
    if (spreadsheetId != null) {
      _spreadsheetID = spreadsheetId;
    } else {
      var lsForm = await getFormUrl();
      if (lsForm != null) {
        _spreadsheetID = lsForm;
      } else {
        _spreadsheetID = formURL;
      }
    }
    await exponentialBackOff.reset();
    final expExcel = await exponentialBackOff.start<Spreadsheet>(
      () => _gsheets.spreadsheet(_spreadsheetID),
      retryIf: (e) {
        return e is GSheetsException;
      },
    );
    if (expExcel.isLeft()) return;
    final excel = expExcel.getRightValue();
    print(excel.sheets[0].title);
    await storeFormUrl(_spreadsheetID);
    if (worksheetTitle != null) {
      _worksheetTitle = worksheetTitle;
    } else {
      _worksheetTitle = excel.sheets[0].title;
    }
    _sheetKeys = <String, int>{};
    _worksheet = excel.worksheetByTitle(_worksheetTitle!)!;

    await exponentialBackOff.reset();
    final expKeys = await exponentialBackOff.start<List<String>>(
      () => _worksheet.values.row(1),
      retryIf: (e) {
        return e is GSheetsException;
      },
    );

    if (expKeys.isLeft()) return;
    final keys = expKeys.getRightValue();
    for (var r in keys) {
      _sheetKeys[r.toLowerCase()] = keys.indexOf(r);
    }
    await getAttendees();
  }

  Future<void> updateSheetKeys() async {
    await getAttendees();
  }

  String get spreadsheetID => _spreadsheetID;
  Future<void> getAttendees() async {
    /// skips the first value which is the header
    // final allRows = (await _worksheet.values.allRows(fill: true)).toList();
    await exponentialBackOff.reset();
    final expAllrows = await exponentialBackOff.start<List<List<String>>>(
      () => _worksheet.values.allRows(fill: true),
      retryIf: (e) {
        return e is GSheetsException;
      },
    );
    if (expAllrows.isLeft()) return;
    final allRows = expAllrows.getRightValue();
    var iterValues = allRows.skip(1);
    var values = iterValues.map((e) => e.map((c) => c.toString()));

    var keys = allRows[0].toList();
    for (var r in keys) {
      _sheetKeys[r.toLowerCase()] = keys.indexOf(r);
    }
    _attendees = values
        .map((value) => Attendee.fromSheets(value.toList(), allRows[0]))
        .toList();
    notifyListeners();
  }

  Future<bool> checkInAttendee(String value, String field,
      {String column = "check-in"}) async {
    await updateSheetKeys();
    // print(value == (await _worksheet.values.row(2))[0]);
    // var column_index = _sheetKeys.keys
    //     .toList()
    //     .where((element) => element.toLowerCase().contains(field))
    //     .toList()[0];
    var rowIndex = attendees.indexWhere((element) => element.name == value);
    if (rowIndex == -1) {
      return false;
    }
    //     .rowIndexOf(value, inColumn: _sheetKeys[column_index]! + 1);
    // if (rowIndex == -1) {
    //   return false;
    // }
    // var result =
    //     await _worksheet.values.insertColumn(4, ["TRUE"], fromRow: rowIndex);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String checkInHour = DateFormat.Hm().format(now);

    // int colIndex = 3;
    int? colIndex = _sheetKeys["Check-in $formattedDate".toLowerCase()];
    print(_attendees[rowIndex].email);
    // if (colIndex != null) {
    if (_attendees[rowIndex].checkIn["Check-in $formattedDate"] == true) {
      return true;
    }
    // }
    rowIndex += 2;
    await exponentialBackOff.reset();
    final expCheckIn = await exponentialBackOff.start<bool>(
      () async {
        // int i = 0;
        // for (i = 0; i < 150; i++) {
        //   print(
        //       // (await _worksheet.values.insertColumnByKey(
        //       //       "Check-in $formattedDate", ["TRUE"],
        //       //       fromRow: rowIndex + 1 + i)) &&
        //       (await _worksheet.values.insertColumnByKey(
        //           "Time $formattedDate", [checkInHour],
        //           fromRow: rowIndex + i)));
        // }

        return
            // (
            // await _worksheet.values.insertColumnByKey(
            //       "Check-in $formattedDate", ["TRUE"], fromRow: rowIndex)) &&
            (await _worksheet.values.insertColumnByKey(
                "Time $formattedDate", [checkInHour],
                fromRow: rowIndex));
      },
      retryIf: (e) {
        print("error happend :  ${(e is GSheetsException)}");
        return e is GSheetsException;
      },
      onRetry: (exeption) {
        print("hello function");
        initializeForWorksheet();
      },
    );
    print(expCheckIn);
    if (expCheckIn.isRight()) {
      final result = expCheckIn.getRightValue();
      // var result = (await _worksheet.values.insertColumnByKey(
      //         "Check-in $formattedDate", ["TRUE"], fromRow: rowIndex)) &&
      //     (await _worksheet.values.insertColumnByKey(
      //         "Time $formattedDate", [checkInHour],
      //         fromRow: rowIndex));
      notifyListeners();
      return result;
    } else {
      Exception e = expCheckIn.getLeftValue();
      print(e);
      return false;
    }
  }

  int get randCred => _randCred;
  Future<void> storeFormUrl(String formUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('formUrl', formUrl);
  }

  Future<String?> getFormUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('formUrl');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Attendee>("attendees", attendees));
    // properties.add(ListPr('count', attendees));
  }
}
