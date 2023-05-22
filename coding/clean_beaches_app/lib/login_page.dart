import 'package:clean_beaches_app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.firstPage = false,
  });

  final bool firstPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Api _api;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final String _ip = '192.168.0.150';
  final int _port = 5000;

  @override
  void initState() {
    _api = Api(ip: _ip, port: _port);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/clean_beach.png'),
              fit: BoxFit.contain,
              opacity: 0.2,
              alignment: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        labelText: 'Nickname',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A nickname must be entered';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A password must be entered';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .secondaryContainer,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                String result = await _api.login(
                                  nickname: _nicknameController.text,
                                  password: _passwordController.text,
                                );

                                if (result == 'OK') {
                                  _prefs.then((SharedPreferences prefs) {
                                    prefs.setString(
                                        'nickname', _nicknameController.text);
                                    prefs.setString(
                                        'password', _passwordController.text);
                                  });

                                  widget.firstPage
                                      ? Navigator.pushNamed(context, '/home')
                                      : Navigator.popAndPushNamed(
                                          context, '/home');
                                }
                              } catch (e) {
                                showSnackBar(
                                  context: context,
                                  text: e.toString(),
                                  icon: Icons.error_outline,
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .errorContainer,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onErrorContainer,
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        widget.firstPage
                            ? Navigator.pushNamed(context, '/register')
                            : Navigator.popAndPushNamed(context, '/register');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
