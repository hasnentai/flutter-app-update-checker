import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tds_desktop_auto_update/update_checker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish (add more as needed)
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const UpdateChecker(),
    );
  }
}



class UpdateChecker extends StatefulWidget {
  const UpdateChecker({super.key});

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  checkForUpdate(context);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Text('Hello FlutterFlow'),
        ),
      );
  }
}
