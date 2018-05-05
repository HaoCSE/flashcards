import 'package:flashcards_common/src/data/data.dart';
import 'package:flashcards_common/src/data/section.dart';
import 'package:meta/meta.dart';

abstract class SubsectionData extends Data implements Comparable<SubsectionData> {
  final int order;
  final SectionData parent;
  final String name;

  // TODO: enhance constructors, do *.fromMap()
  SubsectionData({@required this.name, @required this.order, @required this.parent});

  @override
  int compareTo(SubsectionData other) => order.compareTo(other.order);

  @override
  Map<String, dynamic> toMap();
}
