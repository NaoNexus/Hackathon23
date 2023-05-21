import 'dart:developer';

import 'package:clean_beaches_app/api.dart';
import 'package:clean_beaches_app/home_page.dart';
import 'package:clean_beaches_app/login_page.dart';
import 'package:clean_beaches_app/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF368db3)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const Home(),
        '/register': (_) => const RegisterPage(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage()
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  final String ip = '192.168.0.150';
  final int port = 5000;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: login(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'ERROR',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  snapshot.error?.toString() ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data == 'OK') {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<String?> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String nickname = prefs.getString('nickname') ?? '';
    String password = prefs.getString('password') ?? '';
    try {
      return Api(ip: ip, port: port).login(
        nickname: nickname,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
