import 'package:flutter/material.dart';
import 'SView.dart';
import 'Note.dart';
import 'NotePage.dart';
import 'Utility.dart';
import 'dart:async';

enum viewType { List, Staggered }
final routeObserver = RouteObserver<PageRoute>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware{
  var notesViewType;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _fabVis = true;
  final _fabkey = GlobalKey();
  final duration = Duration(milliseconds: 300);

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  didPopNext() {
    // Show back the FAB on transition back ended
    Timer(duration, () {
      setState(() => _fabVis = true);
    });
  }

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
        floatingActionButton: Visibility(
            visible: _fabVis, child: _buildFab(context, key: _fabkey)));
  }

  Widget _buildFab(context, {key}) => FloatingActionButton(
        onPressed: () => _newNoteTapped(context),
        key: key,
        child: Icon(Icons.add),
//          backgroundColor: Color.fromARGB(255, 59, 73, 73),
//          backgroundColor: Colors.white,
      );

  Widget _body() {
    return Container(child: StaggeredGridPage(notesViewType: notesViewType));
  }

  void _newNoteTapped(BuildContext ctx) {
    setState(() {
      _fabVis = false;
    });
    final RenderBox fabRB = _fabkey.currentContext.findRenderObject();
    final fabSize = fabRB.size;
    final fabOffset = fabRB.localToGlobal(Offset.zero);

    var emptyNote =
        new Note(-1, "", "", DateTime.now(), DateTime.now(), Colors.white);
//        new Note(-1, "", "", DateTime.now(), DateTime.now(), Color.fromARGB(255, 246, 85, 85));
//    Navigator.push(
//        ctx, MaterialPageRoute(builder: (ctx) => NotePage(emptyNote)));
    Navigator.push(
        ctx,
        PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                NotePage(emptyNote),
            transitionsBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secondaryAnimation, Widget child) =>
                _buildTransition(child, animation, fabSize, fabOffset)));
  }

  Widget _buildTransition(Widget page, Animation<double> animation,
      Size fabSize, Offset fabOffset) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab =
        Opacity(opacity: 1 - easeInAnimation.value, child: _buildFab(context));

    Widget positionedClippedChild(Widget child) => Positioned(
          width: size.width,
          height: size.height,
          left: offset.dx,
          top: offset.dy,
          child: ClipRRect(
            borderRadius: radius,
            child: child,
          ),
        );

    return Stack(children: [
      positionedClippedChild(page),
      positionedClippedChild(transitionFab)
    ]);
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
