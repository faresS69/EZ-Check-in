import 'package:flutter/material.dart';

import '../Attendee_details_Screen/attendee_details_screen.dart';
import '../classes/attendee.dart';

class AttendeesList extends StatelessWidget {
  final List<Attendee> attendees;

  const AttendeesList({super.key, required this.attendees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendees List'),
      ),
      body: ListView.builder(
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: ${attendees[index].email}"),
                Text("Phone: ${attendees[index].phoneNumber}"),
              ],
            ),
            onTap: () {
              // Navigate to a screen that shows all the details of the attendee
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendeeDetailsScreen(attendee: attendees[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
