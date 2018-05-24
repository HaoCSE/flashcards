import 'package:flashcards_common/i18n.dart';
import 'package:flashcards_flutter/src/api/firebase_flutter_api.dart';
import 'package:flashcards_flutter/src/components/indicator_loading.dart';
import 'package:flashcards_common/bloc.dart';
import 'package:flashcards_common/data.dart';
import 'package:flashcards_flutter/src/state/container.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class _NullOrEmpty extends StatelessWidget {
  const _NullOrEmpty({this.isLast = false});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    if (isLast) {
      return Container(
        padding: EdgeInsets.only(left: 16.0, bottom: 10.0, right: 10.0, top: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(6.0),
            bottomRight: Radius.circular(6.0),
          ),
          color: Colors.white,
        ),
        child: Text('Empty'),
      );
    }
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}

class _BuildStream extends StatefulWidget {
  const _BuildStream(this.function, this.section, {this.isLast = false});

  final Function function;
  final SectionData section;
  final bool isLast;

  @override
  State<_BuildStream> createState() => _BuildStreamState();
}

class _BuildStreamState extends State<_BuildStream> {
  List<SubsectionData> data = null;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SubsectionData>>(
      stream: widget.function(section: widget.section),
      builder: (BuildContext context, AsyncSnapshot<List<SubsectionData>> snapshot) {
        if (!snapshot.hasData && widget.isLast) {
          return Container(
            padding: EdgeInsets.only(left: 16.0, bottom: 10.0, right: 10.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0),
              ),
              color: Colors.white,
            ),
            child: Loading(),
          );
        }
        if ((data == null || data.isEmpty) && (snapshot.data == null || snapshot.data.isEmpty)) {
          return _NullOrEmpty(isLast: widget.isLast);
        }
        if (snapshot.hasData) {
          data = snapshot.data..sort();
        }
        return Column(
          children: data.map((SubsectionData d) {
            bool last = false;
            if (data.last.compareTo(d) == 0 && widget.isLast) {
              last = true;
            }
            return _SectionRow.generate(d, onTap: () {}, isLast: last);
          }).toList(),
        );
      },
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({@required this.icon, @required this.text, @required this.onTap, this.isLast = false});

  final IconData icon;
  final String text;
  final Function onTap;
  final bool isLast;

  static Widget generate(SubsectionData d, {@required Function onTap, bool isLast = false}) {
    final IconData icon = d is MaterialData ? Icons.description : Icons.create;
    return _SectionRow(
      icon: icon,
      text: d.name,
      onTap: onTap,
      isLast: isLast,
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius br;
    if (isLast) {
      br = BorderRadius.only(
        bottomLeft: Radius.circular(6.0),
        bottomRight: Radius.circular(6.0),
      );
    }

    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 16.0, bottom: 10.0, right: 10.0, top: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: br,
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black87,
                size: 22.0,
              ),
              Text(
                '.',
                style: TextStyle(color: Colors.transparent),
              ),
              Expanded(child: Text(text, style: TextStyle(color: Colors.black87, fontSize: 18.0)))
            ],
          ),
        ));
  }
}

class _SectionWidget extends StatefulWidget {
  const _SectionWidget({@required SectionData this.section});

  final SectionData section;

  @override
  State<_SectionWidget> createState() => _SectionsWidgetState();
}

class _SectionsWidgetState extends State<_SectionWidget> with SingleTickerProviderStateMixin {
//  final SectionListBloc _bloc = SectionListBloc(FirebaseFlutterApi());

  AnimationController _controller;
  CurvedAnimation _easeInAnimation;
  Animation<double> _iconTurns;
  bool _isExpanded = false;

  void _delete() async {
    final state = StateContainer.of(context);
    final bool permission = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(FlashcardsStrings.removeCourseDialog()),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(FlashcardsStrings.no()),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(FlashcardsStrings.yes()),
            ),
          ],
        );
      },
    );

    if (permission) {
      state.sectionListBloc.remove.add(widget.section);
    }
  }

  void _edit() {
    print('edit');
  }

  Widget _generateExpansionTileControls(BuildContext context) {
    final state = StateContainer.of(context);
    List<Widget> controls = [];

    if (widget.section.parent.authorUid == state.authenticationBloc.user.uid) {
      controls = [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.create),
        ),
        IconButton(
          onPressed: _delete,
          icon: Icon(Icons.delete_forever),
        ),
      ];
    }
    controls.add(
      RotationTransition(
        turns: _iconTurns,
        child: Icon(Icons.expand_more),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: controls,
    );
  }

  void _handleTap(bool expanded) {
    setState(() {
      _isExpanded = expanded;
      if (_isExpanded)
        _controller.forward();
      else
        _controller.reverse().then<void>((Null value) {
          setState(() {
            // Rebuild without widget.children.
          });
        });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _easeInAnimation = new CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _iconTurns = new Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    final BorderSide border = BorderSide(color: Theme.of(context).primaryColor, width: 2.0);

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border(
              bottom: border,
              top: border,
              left: border,
              right: border,
            )),
        child: ExpansionTile(
          trailing: _generateExpansionTileControls(context),
          onExpansionChanged: _handleTap,
          title: Container(
            child: Text(widget.section.name, style: TextStyle(color: Colors.white)),
          ),
          children: [
            Column(
              children: <Widget>[
                _BuildStream(state.sectionListBloc.queryExercises, widget.section),
                Divider(
                  color: Colors.transparent,
                  height: 1.0,
                ),
                _BuildStream(state.sectionListBloc.queryMaterials, widget.section, isLast: true)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SectionsList extends StatefulWidget {
  final CourseData course;

  const SectionsList({@required CourseData this.course});

  @override
  State<SectionsList> createState() => _SectionsListState();
}

class _SectionsListState extends State<SectionsList> {
  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    return StreamBuilder<List<SectionData>>(
      stream: state.sectionListBloc.query(course: widget.course),
      builder: (BuildContext context, AsyncSnapshot<List<SectionData>> snapshot) {
        if (!snapshot.hasData) return Loading();

        return ListView(
          children: snapshot.data.map(
            (SectionData section) {
              return _SectionWidget(section: section);
            },
          ).toList(),
        );
      },
    );
  }
}
