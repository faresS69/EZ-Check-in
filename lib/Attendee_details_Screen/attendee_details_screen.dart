import 'package:flutter/material.dart';

import '../classes/attendee.dart';

class AttendeeDetailsScreen extends StatelessWidget {
  final Attendee attendee;

  const AttendeeDetailsScreen({super.key, required this.attendee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendee Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 80.0, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Text(
                attendee.name,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Email: ${attendee.email}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Phone: ${attendee.phoneNumber}',
                style: const TextStyle(fontSize: 18.0),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Check-in Status: ",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: (attendee.checkIn)
                              ? Colors.green[300]
                              : Colors.red[300],
                        ),
                        child: IconButton(
                            onPressed: () => null,
                            color: Colors.white,
                            icon: (attendee.checkIn)
                                ? Icon(
                                    Icons.check,
                                  )
                                : Icon(Icons.close)))
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
