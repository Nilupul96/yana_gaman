import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yana_gaman/ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // navigatorKey: navigationKey,
        theme: ThemeData(
            textTheme: TextTheme(
                // headline1: HeaderStyle,
                // headline2: SubHeaderStyle,
                // button: ButtonTextStyle,
                // subtitle1: BodyTextStyle
                ),
            primarySwatch: Colors.teal,
            appBarTheme: AppBarTheme(brightness: Brightness.light)),
        // routs: <String, WidgetBuilder>{
        //   "/ourMenuScreen": (BuildContext c) => Homepage(curreniIndex: 1),

        // },
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
