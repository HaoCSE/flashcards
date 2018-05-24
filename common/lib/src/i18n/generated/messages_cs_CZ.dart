// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs_CZ locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'cs_CZ';

  static m0(version) =>
      "Verze\n__${version}__\n\nOpen source projekt s cílem vytvořit multiplatformní (tj. web, android, iOS) aplikaci s výukovými kartičkami. Na náš kód se můžete podívat na [GitHubu](https://github.com/tenhobi/flashcards).\n\nProjekt začal jako součást předmětu softwarový týmový projekt na [Fakultě informačních technologií ČVUT v Praze](https://fit.cvut.cz).";

  static m1(score) => "skóre: ${score}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "aboutLicensesText":
            MessageLookupByLibrary.simpleMessage("Aplikace je vyvíjena jako open source software: [licence]()"),
        "aboutNavigationButton": MessageLookupByLibrary.simpleMessage("O aplikaci"),
        "aboutText": m0,
        "addComment": MessageLookupByLibrary.simpleMessage("Přidat komentář"),
        "allCourses": MessageLookupByLibrary.simpleMessage("vše"),
        "appName": MessageLookupByLibrary.simpleMessage("Flashcards"),
        "cannotBeEmpty": MessageLookupByLibrary.simpleMessage("Nemůže být prázdné"),
        "commentsTab": MessageLookupByLibrary.simpleMessage("Komentáře"),
        "createdCourses": MessageLookupByLibrary.simpleMessage("vytvořeno"),
        "descriptionTab": MessageLookupByLibrary.simpleMessage("Popis"),
        "homeNavigationButton": MessageLookupByLibrary.simpleMessage("Domů"),
        "like": MessageLookupByLibrary.simpleMessage("Líbí se mi"),
        "newCourse": MessageLookupByLibrary.simpleMessage("Nový kurz"),
        "newCourseDescription": MessageLookupByLibrary.simpleMessage("Popis"),
        "newCourseDescriptionEmpty": MessageLookupByLibrary.simpleMessage("Popis nemůže být prázdný."),
        "newCourseName": MessageLookupByLibrary.simpleMessage("Název"),
        "newCourseNameEmpty": MessageLookupByLibrary.simpleMessage("Název nemůže být prázdný."),
        "newSection": MessageLookupByLibrary.simpleMessage("Nová sekce"),
        "newSectionName": MessageLookupByLibrary.simpleMessage("Název"),
        "no": MessageLookupByLibrary.simpleMessage("Ne"),
        "noVersion": MessageLookupByLibrary.simpleMessage("Verze nebyla nalezena"),
        "popularCourses": MessageLookupByLibrary.simpleMessage("oblíbené"),
        "remove": MessageLookupByLibrary.simpleMessage("Odstranit"),
        "removeCourseDialog": MessageLookupByLibrary.simpleMessage("Chcete vymazat kurz?"),
        "reportBugNavigationButton": MessageLookupByLibrary.simpleMessage("Nahlásit chybu"),
        "reportUrl": MessageLookupByLibrary.simpleMessage("https://github.com/tenhobi/flashcards/issues/new"),
        "score": m1,
        "searchNavigationButton": MessageLookupByLibrary.simpleMessage("Hledat"),
        "sectionsTab": MessageLookupByLibrary.simpleMessage("Sekce"),
        "settingsNavigationButton": MessageLookupByLibrary.simpleMessage("Nastavení"),
        "signInButton": MessageLookupByLibrary.simpleMessage("Přihlásit se pomocí Google"),
        "signOutNavigationButton": MessageLookupByLibrary.simpleMessage("Odhlásit se"),
        "unlike": MessageLookupByLibrary.simpleMessage("Nelíbí se mi"),
        "yes": MessageLookupByLibrary.simpleMessage("Ano")
      };
}
