import 'package:attendance/attendace.dart';
import 'package:attendance/dataBase/dataBase.dart';
import 'package:attendance/empRegister.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';
import 'logIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var loggedIn = false;
  @override
  Widget build(context) {
    return FutureBuilder(
      future: DataBaseHelpler().queryingAdminTableStatus(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapShot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        loggedIn = snapShot.data as bool;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(),
          routes: <String, WidgetBuilder>{
            '/HomePage': (context) => HomePage(),
            '/LogIn': (context) => LogIn(),
            '/EmployeeCreation':(context) => EmployeeCreation(),
            '/UpdateAttendance':(context) => UpdateAttendance()
          },
          title: 'Attendace',
          home: loggedIn ? HomePage() : LogIn(),
        );
      },
    );
  }
}
