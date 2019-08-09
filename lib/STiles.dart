import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'NotePage.dart';
import 'Note.dart';
import 'Utility.dart';

class MyStaggeredTile extends StatefulWidget {
  final Note note;

  MyStaggeredTile(this.note);

  @override
  _MyStaggeredTileState createState() => _MyStaggeredTileState();
}

class _MyStaggeredTileState extends State<MyStaggeredTile> {
  Color tileColor;
  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    content = widget.note.content;
    tileColor = widget.note.noteColor;
    title = widget.note.title;

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(2),
      child: InkWell(
        splashColor: Color.fromARGB(70, 246, 85, 85),
        highlightColor: Color.fromARGB(30, 246, 85, 85),
        onTap: () => _noteTapped(context),
        child: ListTile(
          title: title != null
              ? Text(title,
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.w500))
              : null,
          subtitle: Text(content, maxLines: 7, textScaleFactor: 1.4),
        ),
      ),
      color: tileColor,
    );
  }

  void _noteTapped(BuildContext context) {
    CentralStation.updateNeeded = false;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePage(widget.note)));
  }
}
