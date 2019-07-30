import 'package:flutter/material.dart';
import 'ColorSlider.dart';
import 'Utility.dart';

enum moreOptions { delete, share, copy }

class MoreOptionsSheet extends StatefulWidget {
  final Color color;
  final DateTime dateEdited;
  final void Function(Color) colorTapped;

  final void Function(moreOptions) optionTapped;

  const MoreOptionsSheet(
      {Key key,
      this.color,
      this.dateEdited,
      this.colorTapped,
      this.optionTapped})
      : super(key: key);

  @override
  _MoreOptionsSheetState createState() => _MoreOptionsSheetState();
}

class _MoreOptionsSheetState extends State<MoreOptionsSheet> {
  var noteColor;

  @override
  void initState() {
    noteColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.noteColor,
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Удалить'),
              onTap: () {
                Navigator.of(context).pop();
                widget.optionTapped(moreOptions.delete);
              }),
          new ListTile(
              leading: new Icon(Icons.content_copy),
              title: new Text('Дублировать'),
              onTap: () {
                Navigator.of(context).pop();
                widget.optionTapped(moreOptions.copy);
              }),
          new ListTile(
              leading: new Icon(Icons.share),
              title: new Text('Поделиться'),
              onTap: () {
                Navigator.of(context).pop();
                widget.optionTapped(moreOptions.share);
              }),
          new Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 44,
              width: MediaQuery.of(context).size.width,
              child: ColorSlider(
                colorTapped: _changeColor,
                noteColor: noteColor,
              ),
            ),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 44,
                child: Center(
                    child: Text(
                        CentralStation.stringFromDateTime(widget.dateEdited))),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          new ListTile()
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() {
      this.noteColor = color;
      widget.colorTapped(color);
    });
  }
}
