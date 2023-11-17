import '../classes/attendee.dart';

List<Attendee> loadAttendeesFromJson() {
  // Assuming your JSON data is in a variable named jsonData
  List<dynamic> jsonData = [
    {
      "name": "John Doe",
      "email": "john.doe@example.com",
      "phoneNumber": "123-456-7890"
    },
    {
      "name": "Jane Smith",
      "email": "jane.smith@example.com",
      "phoneNumber": "555-555-5555"
    },
    {
      "name": "Sam Johnson",
      "email": "sam.johnson@example.com",
      "phoneNumber": "987-654-3210"
    },
    {
      "name": "Alex Brown",
      "email": "alex.brown@example.com",
      "phoneNumber": "111-222-3333"
    },
    {
      "name": "Emily Davis",
      "email": "emily.davis@example.com",
      "phoneNumber": "444-444-4444"
    },
    {
      "name": "Michael Lee",
      "email": "michael.lee@example.com",
      "phoneNumber": "777-777-7777"
    },
    {
      "name": "Sarah Wilson",
      "email": "sarah.wilson@example.com",
      "phoneNumber": "666-666-6666"
    },
    {
      "name": "Ryan Taylor",
      "email": "ryan.taylor@example.com",
      "phoneNumber": "999-999-9999"
    },
    {
      "name": "Olivia Brown",
      "email": "olivia.brown@example.com",
      "phoneNumber": "888-888-8888"
    },
    {
      "name": "Ethan Davis",
      "email": "ethan.davis@example.com",
      "phoneNumber": "222-333-4444"
    }
  ]
  ;

  List<Attendee> attendees = [];

  for (var data in jsonData) {
    // Assuming your Attendee class has a constructor that takes the necessary data
    Attendee attendee = Attendee(
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      // Add any other properties as needed
    );

    attendees.add(attendee);
  }

  return attendees;
}
