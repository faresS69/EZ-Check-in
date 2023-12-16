
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
            mainAxisSize: MainAxisSize.min,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: attendee.checkIn.entries.map((ch) {
                  return Container(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "${ch.key} : ${attendee.checkInTime[ch.key]}",
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: (ch.value)
                                        ? Colors.green[300]
                                        : Colors.red[300],
                                  ),
                                  child: IconButton(
                                      onPressed: () {},
                                      color: Colors.white,
                                      icon: (ch.value)
                                          ? const Icon(
                                              Icons.check,
                                            )
                                          : const Icon(Icons.close)))
                            ]),
                        const SizedBox(
                          height: 10,
                        )
                      ]));
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
