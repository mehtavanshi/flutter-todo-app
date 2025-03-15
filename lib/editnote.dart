import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api/apimethod.dart';
import 'api/task.dart';

class EditNotes extends StatefulWidget {
  final Task task;

  const EditNotes(this.task, {Key? key}) : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink[100]),
        automaticallyImplyLeading: true,
        title: Text(
          "Edit Notes",
          style: TextStyle(
            color: Colors.pink[100],
            fontSize: 29,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Colors.black,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(color: Colors.white, fontSize: 25), // Text color and font size
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.pink[100],fontSize: 22), // Label text color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink[100]!), // Border color when focused
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.white, fontSize: 22), // Text color and font size
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.pink[100],fontSize: 22), // Label text color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink[100]!), // Border color when focused
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Update the task object with new data
                    Task updatedTask = Task(
                      id: widget.task.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      date: widget.task.date,
                      priority: widget.task.priority,
                      checkboxValue: widget.task.checkboxValue,
                    );

                    try {
                      await updateTask(widget.task.id, updatedTask); // Update the task in the API
                      Navigator.pop(context, updatedTask); // Return the updated task to the previous screen
                    } catch (e) {
                      // Handle error
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Failed to update note. Please try again later.'),
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800), // Button text color and font size
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100], // Button background color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Button border radius
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
