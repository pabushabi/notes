import 'package:flutter/material.dart';
import 'StaggeredView.dart';
import 'Note.dart';
import 'NotePage.dart';
import 'Utility.dart';

enum viewType { List, Staggered }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notesViewType;

  @override
  void initState() {
    notesViewType = viewType.Staggered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            brightness: Brightness.light,
            actions: _appBarActions(),
            elevation: 3,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("Заметки")),
        body: SafeArea(
          child: _body(),
          right: true,
          left: true,
          top: true,
          bottom: true,
        ),
        bottomSheet: _bottomBar());
  }

  Widget _body() {
//    print(notesViewType);
    return Container(child: StaggeredGridPage(notesViewType: notesViewType));
  }

  Widget _bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            child: Text("Новая заметка",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            onPressed: () => _newNoteTapped(context)),
      ],
    );
  }

  void _newNoteTapped(BuildContext ctx) {
    var emptyNote =
        new Note(-1, "", "", DateTime.now(), DateTime.now(), Colors.white);
    Navigator.push(
        ctx, MaterialPageRoute(builder: (ctx) => NotePage(emptyNote)));
  }

  void _toggleViewType() {
    setState(() {
      CentralStation.updateNeeded = true;
      notesViewType =
          notesViewType == viewType.List ? viewType.Staggered : viewType.List;
    });
  }

  List<Widget> _appBarActions() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _toggleViewType(),
            child: Icon(
              notesViewType == viewType.List
                  ? Icons.dashboard
                  : Icons.view_agenda,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      )
    ];
  }
}
