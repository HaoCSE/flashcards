// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
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
  get localeName => 'en_US';

  static m0(count) =>
      "${Intl.plural(count, zero: 'žádný hovno', one: 'jedno hovno', two: 'dvě hovna', other: '${count} hovna')}";

  static m1(howMany, userName) =>
      "${Intl.plural(howMany, zero: 'There are no emails left for ${userName}.', one: 'There is ${howMany} email left for ${userName}.', other: 'There are ${howMany} emails left for ${userName}.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "hovno": m0,
        "loginButton": MessageLookupByLibrary.simpleMessage("my login button"),
        "remainingEmailsMessage": m1,
        "signInButton": MessageLookupByLibrary.simpleMessage("my sign in button")
      };
}
