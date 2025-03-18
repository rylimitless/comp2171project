import 'package:flutter/material.dart';
import 'package:rexcommerce/homePage.dart';
import 'package:rexcommerce/itemsListing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RexCommerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 180, 56, 225),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 180, 56, 225)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/categories': (context) => const HomePage(), // Replace with actual Categories page when available
        '/sell-item': (context) => const HomePage(),  // Replace with actual Sell Item page when available
        '/settings': (context) => const HomePage(),   // Replace with actual Settings page when available
        '/itemsListing': (context) => ListingsScreen(), // Replace with actual Items Listing page when available
      },
    );
  }
}