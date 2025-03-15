import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdditionalNotesPage extends StatelessWidget {
  final String title;
  final String additionalNotes;
  final String priority;
  final String date;
  final bool checkboxValue;

  const AdditionalNotesPage({
    Key? key,
    required this.title,
    required this.additionalNotes,
    required this.priority,
    required this.date,
    required this.checkboxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink[100]),
        automaticallyImplyLeading: true,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.pink[100],
            fontSize: 29,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.pink[100],
                fontSize: 22,
              ),
            ),
            SizedBox(height: 8),
            Text(
              additionalNotes,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Priority: $priority',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.pink.shade50,
                fontSize: 22,

              ),
            ),
            SizedBox(height: 16),
            Text(
              'Date: $date',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 16),
            if (checkboxValue)
              ElevatedButton(
                onPressed: () {},
                child: Text('Completed',style: TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.w800),),
              ),
            if (!checkboxValue)
              ElevatedButton(
                onPressed: () {},
                child: Text('Incomplete',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w800),),
              ),

          ],
        ),
      ),
    );
  }
}


