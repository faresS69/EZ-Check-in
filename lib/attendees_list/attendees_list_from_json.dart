import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../classes/attendee.dart';
import "package:gsheets/gsheets.dart";

Future<List<Attendee>> loadAttendeesFromJson() async {
  String credentialsJson =
      await rootBundle.loadString('assets/credentials.json');
  var gsheets = GSheets(jsonDecode(credentialsJson));
  final ss =
      await gsheets.spreadsheet("1lzZvXZ3-Sb2vDSLPZf9Rgo5bQtKCoTHu0EUwCdBNeQU");
  final ws = ss.worksheetByTitle("Sheet1");
  if (ws == null) return List<Attendee>.empty();
  var gsheetsAttendees = await ws.values.allRows(fromRow: 2);

  List<Attendee> attendees = [];

  for (var data in gsheetsAttendees) {
    // Assuming your Attendee class has a constructor that takes the necessary data
    Attendee attendee = Attendee(
        name: data[0],
        email: data[1],
        phoneNumber: data[2],
        checkIn: data[3].toLowerCase() == "true"
        // Add any other properties as needed
        );

    attendees.add(attendee);
  }

  return attendees;
}
