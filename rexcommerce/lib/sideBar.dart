import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class SideBar extends StatelessWidget {
  final String? profileImagePath;
  final String name;
  final String email;

  const SideBar({
    super.key, 
    this.profileImagePath,
    this.name = 'Your Name',
    this.email = 'your.email@example.com',
  });

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
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                  child: profileImagePath != null
                    ? CircleAvatar(
                        radius: 35,
                        backgroundImage: FileImage(File(profileImagePath!)),
                      )
                    : CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // First section (no name)
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
            leading: const Icon(Icons.explore),
            title: Text(
              'Browse',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/productListing');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: Text(
              'Sell Item',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              // Close the drawer first
              Navigator.pop(context);
              // Use push instead of pushReplacement to maintain navigation history
              Navigator.pushNamed(context, '/sell-item');
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: Text(
              'Messages',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/messages');
            },
          ),
          
          // Second section - "Quick Actions"
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
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
        ],
      ),
    );
  }
}