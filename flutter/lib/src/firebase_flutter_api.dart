import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_common/common.dart';
import 'package:flashcards_common/src/data/user.dart';

class FirebaseFlutterApi extends FirebaseApi {
  static final FirebaseFlutterApi _instance = FirebaseFlutterApi._();

  FirebaseFlutterApi._();

  factory FirebaseFlutterApi() => _instance;

  @override
  Stream<List<CourseData>> queryCourses({
    String authorUid,
    CoursesQueryType type = CoursesQueryType.all,
    String name,
  }) {
    StreamController<List<CourseData>> controller = StreamController.broadcast();

    Query courses = Firestore.instance.collection('courses');

    switch (type) {
      case CoursesQueryType.created:
        courses = courses.where('authorUid', isEqualTo: authorUid).orderBy('name');
        break;
      case CoursesQueryType.popular:
        courses = courses.orderBy('stars', descending: true);
        break;
      case CoursesQueryType.all:
      default:
    }

    courses.snapshots.listen((QuerySnapshot snapshot) {
      List<CourseData> dataList = snapshot.documents.map<CourseData>((DocumentSnapshot document) {
        CourseData data = CourseData.fromMap(document.data);

        if (name == null) {
          return data;
        }

        if (data.name.toLowerCase().contains(name.toLowerCase())) {
          return data;
        }

        return null;
      }).toList();

      dataList.removeWhere((CourseData data) => data == null);

      controller.add(dataList);
    });

    return controller.stream;
  }

  @override
  void addCourse(CourseData course) {
    Firestore.instance.collection('courses').add(course.toMap());
  }

  @override
  void addUser(UserData user) {
    Firestore.instance.collection('users').add(user.toMap());
  }

  @override
  Stream<UserData> queryUser(String uid) {
    StreamController<UserData> controller = StreamController.broadcast();

    Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots
        .listen((QuerySnapshot snapshot) {
      controller.add(snapshot.documents
          .map<UserData>((DocumentSnapshot document) {
            return UserData.fromMap(document.data);
          })
          .toList()
          .first);
    });

    return controller.stream;
  }

  @override
  Stream<List<UserData>> queryUsers() {
    StreamController<List<UserData>> controller = StreamController.broadcast();

    Firestore.instance.collection('users').snapshots.listen((QuerySnapshot snapshot) {
      controller.add(snapshot.documents.map<UserData>((DocumentSnapshot document) {
        return UserData.fromMap(document.data);
      }).toList());
    });

    return controller.stream;
  }
}
