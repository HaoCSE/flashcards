import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_common/bloc.dart';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class StateContainer extends StatefulWidget {
  final Widget child;

  final AuthenticationBloc<FirebaseUser> authenticationBloc;
  final CourseListBloc courseListBloc;
  final SectionListBloc sectionListBloc;
  final UserBloc userBloc;

  const StateContainer({
    @required this.child,
    @required this.authenticationBloc,
    @required this.courseListBloc,
    @required this.sectionListBloc,
    @required this.userBloc,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) as _InheritedStateContainer).data;
  }

  @override
  State<StatefulWidget> createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  AuthenticationBloc<FirebaseUser> authenticationBloc;
  CourseListBloc courseListBloc;
  SectionListBloc sectionListBloc;
  UserBloc userBloc;

  @override
  void initState() {
    authenticationBloc = widget.authenticationBloc;
    courseListBloc = widget.courseListBloc;
    sectionListBloc = widget.sectionListBloc;
    userBloc = widget.userBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    courseListBloc.dispose();
    sectionListBloc.dispose();
    userBloc.dispose();
    super.dispose();
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({
    @required this.data,
    @required Widget child,
    Key key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
