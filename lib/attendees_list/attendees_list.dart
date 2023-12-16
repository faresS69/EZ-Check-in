// ignore_for_file: must_be_immutable

import 'package:ez_check_in/SearchAttendees/searchAttendees.dart';
import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:ez_check_in/widgets/attendee_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Attendee_details_Screen/attendee_details_screen.dart';
import '../classes/attendee.dart';

class AttendeesList extends StatelessWidget {
  late List<Attendee> attendees;

  AttendeesList({super.key});
  @override
  Widget build(BuildContext context) {
    // context.read<GoogleSheetsProvider>().getAttendees().then((_) => null);
    attendees = context.watch<GoogleSheetsProvider>().attendees;
    return Scaffold(
      appBar: AppBar(
          title: Row(children: <Widget>[
        const Text('Attendees List'),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search))
      ])),
      body: RefreshIndicator(
          onRefresh: () async {
            await context.read<GoogleSheetsProvider>().getAttendees();
            // attendees = context.read<GoogleSheetsProvider>().attendees;
          },
          child: AttendeeListView(attendees)),
    );
  }
}
