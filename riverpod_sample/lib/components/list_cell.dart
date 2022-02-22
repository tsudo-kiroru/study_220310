import 'package:flutter/material.dart';

class ListCell extends StatelessWidget {
  const ListCell({Key? key, this.buttonTitle = "Button", this.title = "Title", required this.handler}) : super(key: key);

  final String buttonTitle;
  final String title;
  final Function handler;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () { 
                handler();
              },
              child: Text(this.buttonTitle),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(title),
            ),
          ],
        )
      ),
      color: Colors.grey,
    );
  }
}
