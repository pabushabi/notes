import 'package:animations/animations.dart';
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

const double _fabDimension = 56.0;

class _HomePageState extends State<HomePage> with RouteAware {
  var notesViewType;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _fabVis = true;
  final duration = Duration(milliseconds: 300);

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
          elevation: 4,
          centerTitle: true,
          title: Text("Заметки")),
      body: SafeArea(
          child: _body(),
          right: true,
          left: true,
          top: true,
          bottom: true,
        ),
      floatingActionButton: OpenContainer(
        useRootNavigator: true,
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return NotePage(new Note(
              -1, "", "", DateTime.now(), DateTime.now(), Colors.white));
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.secondary,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body() {
    return StaggeredGridPage(notesViewType: notesViewType);
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
          final snackbar = SnackBar(
              content: Text("Feature isn't implemented yet"),
              action: SnackBarAction(label: "Ясно", onPressed: () {}),
              duration: Duration(seconds: 3));
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
