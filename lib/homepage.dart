import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_1/api/apimethod.dart';
import 'package:new_1/api/task.dart';
import 'package:intl/intl.dart';
import 'package:new_1/login/loginpage.dart';
import 'package:new_1/weekwisedisplay.dart';
import 'addnotes.dart';
import 'editnote.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<bool> checkboxValues = [];
  List<Task> todoItems = [];
  DateTime selectedDate = DateTime.now();
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI().then((tasks) {
      setState(() {
        todoItems = tasks;
        checkboxValues = tasks.map((task) => task.checkboxValue).toList();
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: AppBar(
              title: Text(
                "ToDoList",
                style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.pink.shade100
                      : Colors.black,
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.list,
                    size: 35,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.pink.shade50
                        : Colors.pink,
                  ),
                  onPressed: () async {
                    final newText = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeekWiseDisplay()),
                    );
                    if (newText != null) {
                      setState(() {
                        todoItems.add(newText);
                        checkboxValues.add(false);
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    _themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 30,
                    color: Colors.pink[100],
                  ),
                  onPressed: () {
                    setState(() {
                      _themeMode = _themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.assignment_ind,
                    size: 35,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.pink.shade50
                        : Colors.pink,
                  ),
                  onPressed: ()  {
                    _signOut(context);
                    
                  },
                ),
              ],
              backgroundColor:
                  _themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            ),
          ),
          body: Expanded(
            child: Container(
              color: _themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              child: Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 10, 20, 10),
                          child: ElevatedButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(selectedDate),
                              style: TextStyle(
                                color: _themeMode == ThemeMode.dark
                                    ? Colors.pink.shade50
                                    : Colors.pinkAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                        child: ListView.builder(
                          itemCount: todoItems.length,
                          itemBuilder: (context, index) {
                            return buildRow(
                                todoItems[index], checkboxValues[index],
                                (value) {
                              setState(() {
                                checkboxValues[index] = value!;
                              });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newText = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotes()),
              );
              if (newText != null) {
                setState(() {
                  todoItems.add(newText);
                  checkboxValues.add(false);
                });
              }
            },
            backgroundColor:
                _themeMode == ThemeMode.dark ? Colors.white : Colors.pink,
            child: Icon(
              Icons.add,
              size: 30,
              color: _themeMode == ThemeMode.dark
                  ? Colors.black
                  : Colors.pink.shade50,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget buildRow(Task task, bool isChecked, ValueChanged<bool?> onChanged) {
    Color rowColor = determineRowColor(isChecked);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          color: rowColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) async {
                    setState(() {
                      isChecked =
                          value ?? false; // Update local UI state immediately
                    });
                    try {
                      // Call the method to update checkbox value in API
                      await updateCheckboxValue(task.id, isChecked);
                      // Fetch the updated list of tasks from the API
                      List<Task> updatedTasks = await fetchDataFromAPI();
                      // Update the UI with the new list of tasks
                      setState(() {
                        todoItems = updatedTasks;
                        checkboxValues = updatedTasks
                            .map((task) => task.checkboxValue)
                            .toList();
                      });
                    } catch (error) {
                      // Handle error
                      print('Error updating checkbox value: $error');
                      // You can display a snackbar or dialog to inform the user about the error
                    }
                  },
                  activeColor: _themeMode == ThemeMode.dark
                      ? Colors.purple.shade100
                      : Colors.black,
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: (task.title == null)
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white))
                            : Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _themeMode == ThemeMode.dark ? Colors.black87 : Colors.blue.shade50,
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    final newText = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditNotes(task)),
                    );
                    if (newText != null) {
                      setState(() {
                        int index =
                            todoItems.indexWhere((item) => item.id == task.id);
                        if (index != -1) {
                          todoItems[index] = newText;
                        }
                      });
                    }
                  },
                  child: Icon(Icons.edit, color: Colors.black, size: 30),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text(
                              "Are you sure you want to delete this task?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close the dialog
                                try {
                                  await deleteTask(task.id);
                                  setState(() {
                                    int index = todoItems.indexWhere(
                                        (item) => item.id == task.id);
                                    if (index != -1) {
                                      todoItems.removeAt(index);
                                      checkboxValues.removeAt(index);
                                    }
                                  });
                                } catch (e) {
                                  print('Error deleting task: $e');
                                }
                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.delete,
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login or home page after sign-out
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>LoginPage()),
      );// Go back to the previous page
    } catch (e) {
      // Handle sign-out errors
      print('ERROR IN SIGN OUT: $e');
      //Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color determineRowColor(bool isChecked) {
    return isChecked ? Colors.pink.shade300 : Colors.pink.shade100;
  }
}
