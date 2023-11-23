class Attendee {
  final String name;
  final String email;
  final String phoneNumber;
  final bool checkIn;

  Attendee(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.checkIn});

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        checkIn: json["checkIn"]);
  }
  factory Attendee.fromSheets(List<String> sheets) {
    return Attendee(
        name: sheets[0],
        email: sheets[1],
        phoneNumber: sheets[2],
        checkIn: sheets[3].toLowerCase() == "true");
  }
}
