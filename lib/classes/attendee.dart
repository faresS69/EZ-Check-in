class Attendee {
  final String name;
  final String email;
  final String phoneNumber;
  final Map<String, bool> checkIn;
  final Map<String, String> checkInTime;

  Attendee({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.checkIn,
    required this.checkInTime,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        checkIn: {},
        checkInTime: {});
  }
  factory Attendee.fromSheets(List<String> sheets, List<String> keys) {
    var indexes = <String, int>{};
    var checkIn = <String, bool>{};
    var checkIntime = <String, String>{};
    for (var i_k in keys.indexed) {
      if (i_k.$2.toLowerCase().contains("time") == true) {
        var checkInStr = "Check-in ${i_k.$2.split(" ")[1]}";
        checkIntime[checkInStr] =
            sheets[i_k.$1].toLowerCase().length > 0 == true
                ? sheets[i_k.$1]
                : "X";

        checkIn[checkInStr] = sheets[i_k.$1].isNotEmpty ? true : false;
      } else if (i_k.$2
              .toLowerCase()
              .replaceAll(" ", "")
              .contains("fullname") ==
          true) {
        indexes["full name"] = i_k.$1;
      } else if (i_k.$2.toLowerCase().replaceAll(" ", "").contains("email") ==
          true) {
        indexes["email"] = i_k.$1;
      } else if (i_k.$2.toLowerCase().replaceAll(" ", "").contains("phone") ==
          true) {
        indexes["phone"] = i_k.$1;
      }
    }

    return Attendee(
        name: sheets[indexes["full name"]!],
        email: sheets[indexes["email"]!],
        phoneNumber: sheets[indexes["phone"]!],
        checkIn: checkIn,
        checkInTime: checkIntime);
  }
}
