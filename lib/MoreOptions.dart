import 'package:flutter/material.dart';
import 'ColorSlider.dart';
import 'Utility.dart';

enum moreOptions { delete, share }

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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.optionTapped(moreOptions.delete);
                    },
                    icon: Icon(Icons.delete_outline),
                    label: Text("Удалить"))),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.optionTapped(moreOptions.share);
                    },
                    icon: Icon(Icons.share),
                    label: Text("Поделиться"))),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
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
