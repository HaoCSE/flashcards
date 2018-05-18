import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_common/bloc.dart';
import 'package:flashcards_common/api.dart';
import 'package:flashcards_common/data.dart';
import 'package:meta/meta.dart';

class FirebaseFlutterApi extends FirebaseApi {
  static final FirebaseFlutterApi _instance = FirebaseFlutterApi._();

  factory FirebaseFlutterApi() => _instance;

  FirebaseFlutterApi._();

  @override
  Stream<List<CourseData>> queryCourses({
    String authorUid,
    CoursesQueryType type = CoursesQueryType.all,
    String name,
  }) {
    final StreamController<List<CourseData>> controller = StreamController.broadcast();

    Query courses = Firestore.instance.collection('courses');

    switch (type) {
      case CoursesQueryType.created:
        courses = courses.where('authorUid', isEqualTo: authorUid).orderBy('name');
        break;
      case CoursesQueryType.popular:
        //fixme: stars are now collection
        courses = courses.orderBy('stars', descending: true);
        break;
      case CoursesQueryType.all:
      default:
    }

    courses.snapshots.listen((QuerySnapshot snapshot) {
      final List<CourseData> dataList = snapshot.documents.map<CourseData>((DocumentSnapshot document) {
        final Map<String, dynamic> documentData = document.data..addAll(<String, dynamic>{'id': document.documentID});
        final CourseData data = CourseData.fromMap(documentData);

        if (name == null) {
          return data;
        }

        if (data.name.toLowerCase().contains(name.toLowerCase())) {
          return data;
        }

        return null;
      }).toList()
        ..removeWhere((CourseData data) => data == null);

      controller.add(dataList);
    });

    return controller.stream;
  }

  @override
  Stream<List<String>> queryStars({@required CourseData course}) {
    final StreamController<List<String>> controller = StreamController.broadcast();

    Firestore.instance
        .collection('courses')
        .document(course.id)
        .collection('stars')
        .snapshots
        .listen((QuerySnapshot snapshot) {
					controller.add(snapshot.documents.map<String>((DocumentSnapshot document) {
						return document.documentID;
					}).toList());
    });

    return controller.stream;
  }

  @override
  void star({@required CourseData course, @required String userUid}) {
    Firestore.instance.collection('courses').document(course.id).collection('stars').document(userUid).setData({});
  }

  @override
  void unstar({@required CourseData course, @required String userUid}) {
    Firestore.instance.collection('courses').document(course.id).collection('stars').document(userUid).delete();
  }

  @override
  Stream<List<SectionData>> querySections({@required CourseData course}) {
    final StreamController<List<SectionData>> controller = StreamController.broadcast();

    Firestore.instance
        .collection('courses')
        .document(course.id)
        .collection('sections')
        .orderBy('order')
        .snapshots
        .listen((QuerySnapshot snapshot) {
      controller.add(snapshot.documents.map<SectionData>((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data;
        data['id'] = document.documentID;
        final SectionData res = SectionData.fromMap(data, parent: course);

        return res;
      }).toList());
    });

    return controller.stream;
  }

  @override
  Stream<List<SubsectionData>> queryMaterials({@required SectionData section}) {
    final StreamController<List<SubsectionData>> controller = StreamController.broadcast();

    Firestore.instance
        .collection('courses')
        .document(section.parent.id)
        .collection('sections')
        .document(section.id)
        .collection('materials')
        .orderBy('order')
        .snapshots
        .listen((QuerySnapshot snapshot) {
      controller.add(snapshot.documents.map<SubsectionData>((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data;
        data['id'] = document.documentID;
        final MaterialData res = MaterialData.fromMap(data, parent: section);
        return res;
      }).toList());
    });

    return controller.stream;
  }

  @override
  Stream<List<SubsectionData>> queryExercises({@required SectionData section}) {
    final StreamController<List<SubsectionData>> controller = StreamController.broadcast();

    Firestore.instance
        .collection('courses')
        .document(section.parent.id)
        .collection('sections')
        .document(section.id)
        .collection('exercises')
        .orderBy('order')
        .snapshots
        .listen((QuerySnapshot snapshot) {
      controller.add(snapshot.documents.map<SubsectionData>((DocumentSnapshot document) {
        final Map<String, dynamic> data = document.data;
        data['id'] = document.documentID;
        final ExerciseData res = ExerciseData.fromMap(data, parent: section);
        return res;
      }).toList());
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
    final StreamController<UserData> controller = StreamController.broadcast();

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
    final StreamController<List<UserData>> controller = StreamController.broadcast();

    Firestore.instance.collection('users').snapshots.listen((QuerySnapshot snapshot) {
      controller.add(snapshot.documents.map<UserData>((DocumentSnapshot document) {
        return UserData.fromMap(document.data);
      }).toList());
    });

    return controller.stream;
  }

  @override
  Future<Null> updateUser(UserData user) async {
    final QuerySnapshot a =
        await Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).limit(1).getDocuments();
    a.documents.first.reference.updateData(user.toMap());
  }

  @override
  Future<Null> createIfAbsent(UserData user) async {
    final QuerySnapshot a =
        await Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).limit(1).getDocuments();

    if (a.documents.isEmpty) {
      Firestore.instance.collection('users').add(user.toMap());
    }
  }

  @override
  void addSection(SubsectionData section) {
    // TODO: implement addSection
  }

  @override
  Future removeCourse(CourseData course) async {
    await Firestore.instance.collection('courses').document(course.id).delete();
  }
}
