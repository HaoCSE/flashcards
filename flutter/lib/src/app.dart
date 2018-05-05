import 'package:flashcards_common/i18n.dart';
import 'package:flutter/material.dart';

import 'package:flashcards_flutter/src/i18n/delegate.dart';
import 'package:flashcards_flutter/src/screen/landing.dart';
import 'package:flashcards_flutter/src/screen/main.dart';

// These two imports are used just in main, to set things up
import 'package:flutter_localizations/flutter_localizations.dart';

class FlashcardsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlashcardsStrings.appName(),
      home: LandingScreen(
        nextScreen: MainScreen(),
        nextNewUserScreen: MainScreen(),
      ),
      localizationsDelegates: [
        new FlashcardsLocalizationDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}
