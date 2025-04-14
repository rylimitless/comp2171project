import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:forui/forui.dart';
import 'package:forui/assets.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:rexcommerce/home.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool obscureText = true;
  Widget obscureIcon = Icon(Icons.visibility_off_rounded);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
        builder: (context, app, child) => FTheme(
            data: FThemes.slate.light,
            child: FScaffold(
              header: FHeader(
                title: const Text(
                  'Rex Commerce',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              content: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _usernameController,
                        label: Text(
                          'Username',
                        ),
                      ),
                      const SizedBox(height: 16),
                      FTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        suffixBuilder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: obscureIcon,
                              onTap: () {
                                Logger().i("Button Pressed");
                                setState(() {
                                  obscureText = !obscureText;
                                  if (obscureText == true) {
                                    obscureIcon =
                                        Icon(Icons.visibility_off_outlined);
                                  } else {
                                    obscureIcon =
                                        Icon(Icons.visibility_outlined);
                                  }
                                });
                              },
                            ),
                          );
                        },
                        maxLines: 1,
                        obscureText: obscureText,
                        controller: _passwordController,
                        label: Text(
                          'Password',
                        ),
                      ),
                      const SizedBox(height: 16),
                      FButton(
                        onPress: () async {
                          // Handle login logic here
                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          if (_formKey.currentState!.validate()) {

                          
                            bool isLoggedIn = await app.login();

                            Logger().i(isLoggedIn);

                            if (isLoggedIn){
                              toastification.show(
                              // optional if you use ToastificationWrapper
                              title: Text('Logging in'),
                              autoCloseDuration: const Duration(seconds: 2),
                            );

                            if(mounted){
                              // ignore: use_build_context_synchronously
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Home')));
                            }
                            }
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            
                          }
                          // Perform login action
                        },
                        label: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
}
