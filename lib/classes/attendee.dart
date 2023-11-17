class Attendee {
  final String name;
  final String email;
  final String phoneNumber;

  Attendee({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
