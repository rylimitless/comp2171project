import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  _CreateListingScreenState createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isBidding = false;
  bool _loading = false;
  List<File> _images = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCondition;

  final List<String> categories = [
    'Textbooks', 'Electronics', 'Furniture', 'Clothing', 'School Supplies',
    'Sports Equipment', 'Musical Instruments', 'Other'
  ];

  final List<Map<String, String>> conditions = [
    {'value': 'new', 'label': 'New'},
    {'value': 'like_new', 'label': 'Like New'},
    {'value': 'good', 'label': 'Good'},
    {'value': 'fair', 'label': 'Fair'},
    {'value': 'poor', 'label': 'Poor'}
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('At least one image is required')),
        );
        return;
      }
      setState(() {
        _loading = true;
      });
      
      // Simulate submission delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _loading = false;
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Listing')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Title is required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (value) => value!.isEmpty ? 'Description is required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) => value == null ? 'Category is required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  items: conditions.map((condition) {
                    return DropdownMenuItem(
                      value: condition['value'],
                      child: Text(condition['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCondition = value),
                  decoration: InputDecoration(labelText: 'Condition'),
                  validator: (value) => value == null ? 'Condition is required' : null,
                ),
                SwitchListTile(
                  title: Text('This item is for bidding only'),
                  value: _isBidding,
                  onChanged: (value) => setState(() => _isBidding = value),
                ),
                if (!_isBidding)
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price (\$)'),
                    validator: (value) {
                      if (!_isBidding && (value == null || value.isEmpty)) {
                        return 'Price is required unless item is for bidding';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                Text('Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Upload Image'),
                ),
                Wrap(
                  spacing: 8,
                  children: List.generate(_images.length, (index) {
                    return Stack(
                      children: [
                        Image.file(_images[index], width: 100, height: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _removeImage(index),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Meetup Location'),
                  validator: (value) => value!.isEmpty ? 'Meetup location is required' : null,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _loading ? null : _submitForm,
                      child: _loading ? CircularProgressIndicator() : Text('Create Listing'),
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
