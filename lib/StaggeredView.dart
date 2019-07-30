import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Note.dart';
import 'SQLiteHandler.dart';
import 'Utility.dart';
import 'StaggeredTiles.dart';
import 'HomePage.dart';

class StaggeredGridPage extends StatefulWidget {
  final notesViewType;

  const StaggeredGridPage({Key key, this.notesViewType}) : super(key: key);

  @override _StaggeredGridPageState createState() => _StaggeredGridPageState();
}

class _StaggeredGridPageState extends State<StaggeredGridPage> {
  var noteDB = NotesDBHandler();
  List<Map<String, dynamic>> _allNotesInQueryResult = [];
  viewType notesViewType;

  @override void initState() {
    super.initState();
    this.notesViewType = widget.notesViewType;
  }

  @override void setState(fn) {
    super.setState(fn);
    this.notesViewType = widget.notesViewType;
  }

  @override Widget build(BuildContext context) {
    GlobalKey _stagKey = GlobalKey();

//    print("update needed?: ${CentralStation.updateNeeded}");
    if (CentralStation.updateNeeded) retrieveAllNotesFromDB();
    return Container(
        child: Padding(padding: _paddingForView(context),
          child: new StaggeredGridView.count(
            key: _stagKey,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            crossAxisCount: _colForStaggeredView(context),
            children: List.generate(_allNotesInQueryResult.length, (i) {
              return _tileGenerator(i);
            }),
            staggeredTiles: _tilesForView(),
          ),
        )
    );
  }

  int _colForStaggeredView(BuildContext context) {
    if (widget.notesViewType != viewType.List)
      return MediaQuery
          .of(context)
          .size
          .width > 600 ? 3 : 2;
    return 1;
  }

  List<StaggeredTile> _tilesForView() {
    return List.generate(_allNotesInQueryResult.length, (i) {
      return StaggeredTile.fit(1);
    });
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double padding;
    double topBottom = 8;
    padding = width > 500 ? width * 0.05 : 8;
    return EdgeInsets.only(
        left: padding, right: padding, top: topBottom, bottom: topBottom);
  }

  MyStaggeredTile _tileGenerator(int i) {
    return MyStaggeredTile(Note(_allNotesInQueryResult[i]["id"],
        _allNotesInQueryResult[i]["title"] == null ? "" : utf8.decode(
            _allNotesInQueryResult[i]["title"]),
        _allNotesInQueryResult[i]["content"] == null ? "" : utf8.decode(
            _allNotesInQueryResult[i]["content"]),
        DateTime.fromMicrosecondsSinceEpoch(
            _allNotesInQueryResult[i]["dateCreated"] * 1000),
        DateTime.fromMicrosecondsSinceEpoch(
            _allNotesInQueryResult[i]["dateEdited"] * 1000),
        Color(_allNotesInQueryResult[i]["noteColor"])
    ));
  }

  void retrieveAllNotesFromDB() {
    var _testData = noteDB.selectAllNotes();
    _testData.then((val){
      setState((){
        this._allNotesInQueryResult = val;
        CentralStation.updateNeeded = false;
      });
    });
  }
}