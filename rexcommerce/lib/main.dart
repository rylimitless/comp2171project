import 'package:flutter/material.dart';
import 'package:rexcommerce/homePage.dart';
import 'package:rexcommerce/myListing.dart';
import 'package:rexcommerce/productListing.dart';
import 'package:rexcommerce/profilePage.dart';
import 'package:rexcommerce/sell_Item.dart';
import 'package:rexcommerce/studentPromo.dart';
import 'biddingPage.dart';

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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => ProfilePage(),
        '/sell-item': (context) => const CreateListingScreen(),  // Replace with actual Sell Item page when available
        '/settings': (context) => const HomePage(),   // Replace with actual Settings page when available
        '/productListing': (context) => ListingsScreen(), // Replace with actual Items Listing page when available
        '/myListings': (context) => MyListingsScreen(), // Replace with actual My Listings page when available
        '/messages': (context) => const MessagesPage(), // Replace with your actual MessagesPage
        '/bidding': (context) => const BiddingPage(),
        '/student-promo': (context) => const StudentPromotion(), // Replace with your actual StudentPromoPage
        '/settings': (context) => const SettingsPage(), // Replace with your actual SettingsPage
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Messages Page')));
  }
}

class StudentPromoPage extends StatelessWidget {
  const StudentPromoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Student Promo Page')));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Settings Page')));
  }
}