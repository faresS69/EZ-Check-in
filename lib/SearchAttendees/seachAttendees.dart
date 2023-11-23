import 'package:ez_check_in/Attendee_details_Screen/attendee_details_screen.dart';
import 'package:ez_check_in/classes/attendee.dart';
import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  late List<Attendee> _items;
  List<Attendee> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _items = context.read<GoogleSheetsProvider>().attendees;
    _filteredItems = _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _filteredItems = _items
                  .where((item) =>
                      (item.email
                          .toLowerCase()
                          .contains(value.toLowerCase())) ||
                      item.name.toLowerCase().contains(value.toLowerCase()) ||
                      item.phoneNumber
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                  .toList();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search...',
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: _filteredItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const CircleAvatar(
                // You can customize the avatar icon as needed
                child: Icon(Icons.person),
              ),
              title: Text(
                _filteredItems[index].name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email: ${_filteredItems[index].email}"),
                  Text("Phone: ${_filteredItems[index].phoneNumber}"),
                ],
              ),
              trailing: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: (_filteredItems[index].checkIn)
                        ? Colors.green[300]
                        : Colors.red[300],
                  ),
                  child: IconButton(
                      onPressed: () => null,
                      color: Colors.white,
                      icon: (_filteredItems[index].checkIn)
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
                        AttendeeDetailsScreen(attendee: _filteredItems[index]),
                  ),
                );
              },
            );
          }),
    );
  }
}
