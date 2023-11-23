// ignore_for_file: must_be_immutable

import 'package:ez_check_in/SearchAttendees/seachAttendees.dart';
import 'package:ez_check_in/attendees_list/attendees_list_from_json.dart';
import 'package:ez_check_in/providers/gsheets_provider.dart';
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
          Text('Attendees List'),
          Spacer(),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              icon: Icon(Icons.search))
        ])),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<GoogleSheetsProvider>().getAttendees();
            // attendees = context.read<GoogleSheetsProvider>().attendees;
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: attendees.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const CircleAvatar(
                  // You can customize the avatar icon as needed
                  child: Icon(Icons.person),
                ),
                title: Text(
                  attendees[index].name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${attendees[index].email}"),
                    Text("Phone: ${attendees[index].phoneNumber}"),
                  ],
                ),
                trailing: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: (attendees[index].checkIn)
                          ? Colors.green[300]
                          : Colors.red[300],
                    ),
                    child: IconButton(
                        onPressed: () => null,
                        color: Colors.white,
                        icon: (attendees[index].checkIn)
                            ? Icon(
                                Icons.check,
                              )
                            : Icon(Icons.close))),
                onTap: () {
                  // Navigate to a screen that shows all the details of the attendee
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AttendeeDetailsScreen(attendee: attendees[index]),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
