import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:new_1/homepage.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _checkboxValue = false;
  String _selectedPriority = 'Low';
  List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    // Initialize checkbox value to false when the widget initializes
    _checkboxValue = false;
  }

  Future<void> saveNote() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Format the selected date
    String formattedDate = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';

    // Send the data to your API
    final response = await http.post(
      Uri.parse('http://6571fb81d61ba6fcc0142380.mockapi.io/ToDoList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Title': title,
        'Description': description,
        'Date': formattedDate,
        'Priority': _selectedPriority,
        'Checkboxvalue': _checkboxValue,
      }),
    );

    if (response.statusCode == 201) {
      // Task created successfully, you can navigate back or show a success message
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save note. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Note",
          style: TextStyle(
            color: Colors.pink[100],
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.pink[200]),
      ),
      body: Expanded(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.pink[100], fontSize: 25),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink[50]!),
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.pink[100], fontSize: 24),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink[50]!),
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Select Date: ', style: TextStyle(color: Colors.pink[100], fontSize: 24,fontWeight: FontWeight.w500)),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(_selectedDate),
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Priority: ', style: TextStyle(color: Colors.pink[100], fontSize: 24,fontWeight: FontWeight.w500)),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _selectedPriority,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
                      items: _priorities.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.pink[200], fontSize: 24)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                    onPressed: saveNote,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Save', style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w600)),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.pink[100],
                      textStyle: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
