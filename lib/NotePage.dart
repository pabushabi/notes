import 'package:flutter/material.dart';
import 'Note.dart';
import 'SQLiteHandler.dart';
import 'dart:async';
import 'Utility.dart';
import 'MoreOptionsSheet.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';

class NotePage extends StatefulWidget {
  final Note noteInEditing;

  NotePage(this.noteInEditing);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  var noteColor;
  bool _isNewNote = false;
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  String _titleFromInitial;
  String _contentFromInitial;
  DateTime _lastEdited;

  var _editableNote;
  Timer _persistenceTimer;

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _editableNote = widget.noteInEditing;
    _titleController.text = _editableNote.title;
    _contentController.text = _editableNote.content;
    noteColor = _editableNote.noteColor;
    _lastEdited = widget.noteInEditing.dateEdited;
    _titleFromInitial = widget.noteInEditing.title;
    _contentFromInitial = widget.noteInEditing.content;

    if (widget.noteInEditing.id == -1) _isNewNote = true;
    _persistenceTimer = new Timer.periodic(Duration(seconds: 5), (timer) {
      _persistData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_editableNote.id == -1 && _editableNote.title.isEmpty)
      FocusScope.of(context).requestFocus(_titleFocus);
    return WillPopScope(
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(
            color: Colors.black87,
          ),
          actions: _archiveAction(context),
          elevation: 3,
          backgroundColor: noteColor,
          title: pageTitle(),
        ),
        body: _body(context),
      ),
      onWillPop: _readyToPop,
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      color: noteColor,
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(border: Border.all(color: CentralStation.borderColor,width: 1 ),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                  child: EditableText(
                      onChanged: (str) => {updateNoteObject()},
                      maxLines: 1,
                      controller: _titleController,
                      focusNode: _titleFocus,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      cursorColor: Colors.blue,
                      backgroundCursorColor: Colors.blue), //blue
                ),
              ),
              Divider(color: CentralStation.borderColor),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color: CentralStation.borderColor,width: 1 ),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                  child: EditableText(
                      onChanged: (str) => {updateNoteObject()},
                      maxLines: 500,
                      controller: _contentController,
                      focusNode: _contentFocus,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      cursorColor: Colors.blue,
                      backgroundCursorColor: Colors.blue),
                ),
              )
            ],
          ),
          left: true,
          right: true,
          top: false,
          bottom: false),
    );
  }

  Widget pageTitle() {
    return Text(_editableNote.id == -1 ? "Новая заметка" : "Редактировать");
  }

  List<Widget> _archiveAction(BuildContext context) {
    List<Widget> actions = [];
    if (widget.noteInEditing.id != -1) {
      actions.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _undo(),
            child: Icon(
              Icons.undo,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      ));
    }
    actions += [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _archivePopup(context),
            child: Icon(
              Icons.archive,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => bottomSheet(context),
            child: Icon(
              Icons.more_vert,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      ),
    ];
    return actions;
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return MoreOptionsSheet(
              color: noteColor,
              colorTapped: _changeColor,
              optionTapped: bottomSheetOptionTappedHandler,
              dateEdited: _editableNote.dateEdited);
        });
  }

  void _persistData() {
    updateNoteObject();

    if (_editableNote.content.isNotEmpty) {
      var noteDB = NotesDBHandler();

      if (_editableNote.id == -1) {
        Future<int> autoIncrementedId = noteDB.insertNote(_editableNote, true);
        autoIncrementedId.then((value) {
          _editableNote.id = value;
        });
      } else {
        noteDB.insertNote(_editableNote, false);
      }
    }
  }

  void updateNoteObject() {
    _editableNote.content = _contentController.text;
    _editableNote.title = _titleController.text;
    _editableNote.noteColor = noteColor;

    if (!(_editableNote.title == _titleFromInitial &&
            _editableNote.content == _contentFromInitial) ||
        (_isNewNote)) {
      _editableNote.dateEdited = DateTime.now();
      CentralStation.updateNeeded = true;
    }
  }

  void bottomSheetOptionTappedHandler(moreOptions tappedOption) {
    switch (tappedOption) {
      case moreOptions.delete:
        {
          if (_editableNote.id != -1) {
            _deleteNote(_globalKey.currentContext);
          } else {
            _exitWithoutSaving(context);
          }
          break;
        }
      case moreOptions.share:
        {
          if (_editableNote.content.isNotEmpty) {
            Share.share("${_editableNote.title}\n${_editableNote.content}");
          }
          break;
        }
      case moreOptions.copy:
        {
          _copy();
          break;
        }
    }
  }

  void _deleteNote(BuildContext context) {
    if (_editableNote.id != -1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Удалить заметку?"),
              content: Text("Это действие нельзя обратить"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("Нет")),
                FlatButton(
                    onPressed: () {
                      _persistenceTimer.cancel();
                      var noteDB = NotesDBHandler();
                      Navigator.of(context).pop();
                      noteDB.deleteNote(_editableNote);
                      CentralStation.updateNeeded = true;

                      Navigator.of(context).pop();
                    },
                    child: Text("Да")),
              ],
            );
          });
    }
  }

  void _changeColor(Color newColorSelected) {
    setState(() {
      noteColor = newColorSelected;
      _editableNote.noteColor = newColorSelected;
    });
    _persistColorChange();
    CentralStation.updateNeeded = true;
  }

  void _persistColorChange() {
    if (_editableNote.id != -1) {
      var noteDB = NotesDBHandler();
      _editableNote.noteColor = noteColor;
      noteDB.insertNote(_editableNote, false);
    }
  }

  Future<bool> _readyToPop() async {
    _persistenceTimer.cancel();
    _persistData();
    return true;
  }

  void _archivePopup(BuildContext context) {
    if (_editableNote.id != -1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Архивировать?"),
              content: Text("Заметка будет добавлена в архив"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("Нет")),
                FlatButton(
                    onPressed: () => _archiveThisNote(context),
                    child: Text("Да")),
              ],
            );
          });
    } else {
      _exitWithoutSaving(context);
    }
  }

  void _exitWithoutSaving(BuildContext context) {
    _persistenceTimer.cancel();
    CentralStation.updateNeeded = false;
    Navigator.of(context).pop();
  }

  void _archiveThisNote(BuildContext context) {
    Navigator.of(context).pop();
    _editableNote.isArchived = 1;
    var noteDB = NotesDBHandler();
    noteDB.archiveNote(_editableNote);
    CentralStation.updateNeeded = true;
    _persistenceTimer.cancel();

    Navigator.of(context).pop();
    // TODO: OPTIONAL show the toast of deletion completion
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: Text("Заметка удалена")));
  }

  void _copy() {
    var noteDB = NotesDBHandler();
    Note copy = Note(-1, _editableNote.title, _editableNote.content,
        DateTime.now(), DateTime.now(), _editableNote.noteColor);

    var status = noteDB.copyNote(copy);
    status.then((querySuccess) {
      if (querySuccess) {
        CentralStation.updateNeeded = true;
        Navigator.of(_globalKey.currentContext).pop();
      }
    });
  }

  void _undo() {
    _titleController.text = _titleFromInitial; // widget.noteInEditing.title;
    _contentController.text =
        _contentFromInitial; // widget.noteInEditing.content;
    _editableNote.dateEdited =
        _lastEdited; // widget.noteInEditing.date_last_edited;
  }
}
