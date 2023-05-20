import 'package:clean_beaches_app/api.dart';
import 'package:clean_beaches_app/home_page.dart';
import 'package:clean_beaches_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String ip = '192.168.0.150';
  final int port = 5000;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) {
        String username = _prefs
            .then((SharedPreferences value) => value.getString('nickname'))
            .toString();
        String password = _prefs
            .then((SharedPreferences value) => value.getString('password'))
            .toString();
        if (Api(ip: ip, port: port)
                .checkUsernameAndPassword(username, password)
                .toString() ==
            'OK') {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      }),
    );
  }
}
