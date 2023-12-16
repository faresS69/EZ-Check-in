import 'package:ez_check_in/Attendee_details_Screen/attendee_details_screen.dart';
import 'package:ez_check_in/classes/attendee.dart';
import 'package:flutter/material.dart';

class AttendeeListView extends StatelessWidget {
  List<Attendee> _attendees = <Attendee>[];
  AttendeeListView(
    List<Attendee> attendees, {
    super.key,
  }) {
    this._attendees = attendees;
  }

  @override
  Widget build(BuildContext context) {
    var attendees = _attendees;
    return ListView.builder(
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
          trailing: Column(children: [
            const Text(
              "Check-in",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "${attendees[index].checkIn.values.where((element) => element == true).length}/${attendees[index].checkIn.length} days",
              style: TextStyle(fontSize: 16),
            )
          ]),
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
    );
  }
}
