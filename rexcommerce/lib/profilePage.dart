import 'package:flutter/material.dart';
import 'package:rexcommerce/sideBar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showEditModal = false;
  String? newProfilePic;
  Map<String, String> formData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'residence': 'New York, USA',
    'phoneNumber': '+1 234 567 890',
  };

  void handleImageChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        newProfilePic = image.path;
      });
    }
  }

  void handleSubmit() {
    setState(() {
      showEditModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      drawer: SideBar(
        profileImagePath: newProfilePic,
        name: formData['name']!,
        email: formData['email']!,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: handleImageChange,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        backgroundImage: newProfilePic != null 
                          ? FileImage(File(newProfilePic!)) 
                          : null,
                        child: newProfilePic == null ? Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ) : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(formData['name']!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(formData['email']!),
                Text(formData['residence']!),
                Text(formData['phoneNumber']!),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => showEditModal = true),
                  child: Text('Edit Profile'),
                ),
                if (showEditModal)
                  AlertDialog(
                    title: Text('Edit Profile'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Name'),
                          onChanged: (value) => formData['name'] = value,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Email'),
                          onChanged: (value) => formData['email'] = value,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Residence'),
                          onChanged: (value) => formData['residence'] = value,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Phone Number'),
                          onChanged: (value) => formData['phoneNumber'] = value,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => setState(() => showEditModal = false),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: handleSubmit,
                        child: Text('Save Changes'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}