import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'NotePage.dart';
import 'Note.dart';

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

    return OpenContainer(
      closedElevation: 0,
      closedColor: tileColor,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return NotePage(widget.note);
      },
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(50, 27, 27, 27)),
                borderRadius: BorderRadius.circular(10.0)),
            child: Ink(
                child: InkWell(
                    splashColor: Color.fromARGB(70, 246, 85, 85),
                    highlightColor: Color.fromARGB(30, 246, 85, 85),
                    onTap: openContainer,
                    child: ListTile(
                      title: Text(title,
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle:
                          Text(content, maxLines: 7, textScaleFactor: 1.4),
                    ))));
      },
    );
  }
}
