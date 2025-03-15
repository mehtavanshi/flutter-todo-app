import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_1/homepage.dart';
import 'additionalnotespage.dart';
import 'api/apimethod.dart';
import 'api/task.dart';

class WeekWiseDisplay extends StatefulWidget {
  @override
  _WeekWiseDisplayState createState() => _WeekWiseDisplayState();
}

class _WeekWiseDisplayState extends State<WeekWiseDisplay> {
  late Future<List<Task>> _fetchWeekNotes;
  String _selectedPriority = 'All';
  List<String> _priorities = ['All', 'High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _fetchWeekNotes =
        fetchWeekNotes(); // Call the function to fetch week notes data
  }

  Future<List<Task>> fetchWeekNotes() async {
    List<Task> tasks = await fetchDataFromAPI();
    return tasks;
  }

  List<Task> filterTasksByPriority(List<Task> tasks) {
    if (_selectedPriority == 'All') {
      return tasks;
    } else {
      return tasks.where((task) => task.priority == _selectedPriority).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.pink[100]),
            automaticallyImplyLeading: true,
            title: Text(
              "Weekly Notes",
              style: TextStyle(
                color: Colors.pink[100],
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 25,
                  color: Colors.pink[100],
                ),
                onPressed: () async {
                  final newText = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );

                },
              ),
            ],
            backgroundColor: Colors.black87,
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Expanded(
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _selectedPriority,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  },
                  items:
                      _priorities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.pink.shade200),
                      ),

                    );
                  }).toList(),
                ),
                Expanded(
                  child: FutureBuilder<List<Task>>(
                    future: _fetchWeekNotes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Task> filteredTasks =
                            filterTasksByPriority(snapshot.data!);
                        return ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            Task task = filteredTasks[index];
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: WeekNotesCard(
                                title: task.title,
                                additionalNotes: task.description,
                                priority: task.priority,
                                date: task.date,
                                checkboxValue: task.checkboxValue,
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
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

class WeekNotesCard extends StatelessWidget {
  final String title;
  final String additionalNotes;
  final String date;
  final String priority;
  final bool checkboxValue;

  const WeekNotesCard({
    Key? key,
    required this.title,
    required this.additionalNotes,
    required this.date,
    required this.priority,
    required this.checkboxValue,
  }) : super(key: key);

  Color determineRowColor() {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.yellow;
      case 'Low':
        return Colors.pink;
      default:
        return Colors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalNotesPage(
              title: title,
              date: date,
              additionalNotes: additionalNotes,
              priority: priority,
              checkboxValue: checkboxValue,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        color: determineRowColor(),
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 10),
              Text(
                additionalNotes,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(WeekWiseDisplay());
}
