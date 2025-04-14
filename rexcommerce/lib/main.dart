import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:rexcommerce/authentication/login.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}
//

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const LoginPage(),
      ),
    );
  }
}


