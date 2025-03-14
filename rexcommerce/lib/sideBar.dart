import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 175, 16, 183),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: const NetworkImage(
                    'https://images.unsplash.com/photo-1541546789-bf45d4d548d2',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your Name',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'your.email@example.com',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu items
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(
              'Categories',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/categories');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: Text(
              'Sell Item',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/sell-item');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Are you sure you want to log out?',
                      style: GoogleFonts.poppins(),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                        onPressed: () {
                          // Implement actual logout functionality here
                          Navigator.of(context).pop();
                          // After logout, navigate to login screen
                          // Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}