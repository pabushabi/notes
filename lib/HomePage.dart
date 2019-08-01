import 'package:flutter/material.dart';
import 'SView.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    notesViewType = viewType.Staggered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            brightness: Brightness.dark,
            actions: _appBarActions(context),
            elevation: 3,
//            backgroundColor: Color.fromARGB(255, 59, 73, 73),
            centerTitle: true,
            title: Text("Заметки")),
        body: SafeArea(
          child: _body(),
          right: true,
          left: true,
          top: true,
          bottom: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _newNoteTapped(context),
          child: Icon(Icons.add),
//          backgroundColor: Color.fromARGB(255, 59, 73, 73),
        ));
  }

  Widget _body() {
//    print(notesViewType);
    return Container(child: StaggeredGridPage(notesViewType: notesViewType));
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

  List<Widget> _appBarActions(BuildContext ctx) {
    return [
      IconButton(
        onPressed: () {
          /*TODO: search*/
          final snackbar =
              SnackBar(
                  content: Text("Feature isn't implemented yet"),
                  action: SnackBarAction(
                      label: "Ясно",
                      onPressed: () {}
                  ),
                  duration: Duration(seconds: 3)
              );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        },
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      IconButton(
        onPressed: () => _toggleViewType(),
        icon: Icon(
          notesViewType == viewType.List ? Icons.dashboard : Icons.view_agenda,
          color: Colors.white,
        ),
      ),
    ];
  }
}
