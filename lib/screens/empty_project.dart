import 'package:flutter/material.dart';

class EmptyProjectPage extends StatefulWidget {
  @override
  _EmptyProjectPageState createState() => _EmptyProjectPageState();
}

class _EmptyProjectPageState extends State<EmptyProjectPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 400,
              width: 400,
              child: Image(
                image: AssetImage("assets/images/project-management.png"),
              ),
            ),
            Text(
              "Proje Yoktur",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
