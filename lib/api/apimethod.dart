import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_1/api/task.dart';
import 'package:http/http.dart' as http;

String baseUrl = 'http://6571fb81d61ba6fcc0142380.mockapi.io/ToDoList';

Future<List<Task>> fetchDataFromAPI() async {
  final response = await http.get(Uri.parse(baseUrl));

  // http://6571fb81d61ba6fcc0142380.mockapi.io/ToDoList

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    List<Task> tasks = jsonData.map((taskJson) => Task.fromJson(taskJson)).toList();
    return tasks;
  } else {
    throw Exception('Failed to fetch data from the API');
  }
}
// Add or create a new task
Future<Task> createTask(String title, String description, String date, String priority, bool checkboxValue) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'Title': title,
      'Description': description,
      'Date': date,
      'Priority': priority,
      'Checkboxvalue': checkboxValue,
    }),
  );

  if (response.statusCode == 201) {
    return Task.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create task');
  }
}


// Update an existing task
Future<void> updateTask(String taskId, Task updatedTask) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/$taskId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(updatedTask.toJson()),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update task');
  }
}


// Patch an existing task (partial update)
Future<void> patchTask(String taskId, Map<String, dynamic> updates) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/$taskId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(updates),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to patch task');
  }
}

// Delete an existing task
Future<void> deleteTask(String taskId) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/$taskId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete task');
  }
}




Future<List<Task>> updateCheckboxValue(String taskId, bool newValue) async {
  try {
    // Send a patch request to update the checkbox value
    await http.patch(
      Uri.parse('$baseUrl/$taskId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Checkboxvalue': newValue,
      }),
    );

    // Fetch and return updated list of tasks after updating the checkbox value
    return await fetchDataFromAPI();
  } catch (error) {
    // Handle any errors
    print('Error updating checkbox value: $error');
    throw error; // Rethrow the error for handling in UI
  }
}

Color determineRowColor(bool isChecked) {
  return isChecked ? Colors.white60 : Colors.pink.shade100;
}


