import 'package:flutter/material.dart';
import 'sideBar.dart'; // Import SideBar widget
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io'; // Add this import for File

class StudentPromotion extends StatefulWidget {
  const StudentPromotion({super.key});

  @override
  _StudentPromotionState createState() => _StudentPromotionState();
}

class _StudentPromotionState extends State<StudentPromotion> {
  // Custom date formatting function
  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  // Controllers for form fields
  final _promoNameController = TextEditingController();
  final _promoDescriptionController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _promoCodeController = TextEditingController();
  
  // For date selection
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  
  // Store created promotions
  final List<Promotion> _promotions = [];
  
  // For discount type selection
  String _discountType = 'Percentage';
  
  // Add loading state
  bool _loading = false;
  
  // Add image picker
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  
  @override
  void dispose() {
    _promoNameController.dispose();
    _promoDescriptionController.dispose();
    _discountAmountController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Promotions'),
        backgroundColor: const Color.fromARGB(255, 180, 56, 225),
      ),
      drawer: const SideBar(), // Add SideBar as drawer
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section for creating new promotions
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create New Promotion',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _promoNameController,
                      decoration: const InputDecoration(
                        labelText: 'Promotion Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _promoDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _discountAmountController,
                            decoration: const InputDecoration(
                              labelText: 'Discount Amount',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Discount Type',
                              border: OutlineInputBorder(),
                            ),
                            value: _discountType,
                            items: ['Percentage', 'Fixed Amount']
                                .map((label) => DropdownMenuItem(
                                      value: label,
                                      child: Text(label),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _discountType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _promoCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Promo Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null && picked != _startDate) {
                                setState(() {
                                  _startDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                formatDate(_startDate),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: _startDate,
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null && picked != _endDate) {
                                setState(() {
                                  _endDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'End Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                formatDate(_endDate),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Promotion Image',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              _selectedImage != null
                                ? Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: const Center(
                                      child: Text('No image selected'),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 180, 56, 225),
                          ),
                          child: const Text('Upload Image'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // Update the button to match the Create Listing button style
                    ElevatedButton(
                      onPressed: _loading ? null : _createPromotion,
                      child: _loading 
                          ? const CircularProgressIndicator() 
                          : const Text('Create Promotion'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20.0),
            
            // Section for viewing existing promotions
            const Text(
              'Available Promotions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            _promotions.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No promotions created yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _promotions.length,
                    itemBuilder: (context, index) {
                      final promo = _promotions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Add image to the promotion card
                            if (promo.image != null)
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                child: Image.file(
                                  promo.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(promo.name),
                                  Chip(
                                    backgroundColor: promo.isApplied ? Colors.green[100] : Colors.grey[200],
                                    label: Text(
                                      promo.isApplied ? 'Applied' : 'Not Applied',
                                      style: TextStyle(
                                        color: promo.isApplied ? Colors.green[800] : Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(promo.description),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Discount: ${promo.discountAmount}${promo.discountType == 'Percentage' ? '%' : '\$'} | Code: ${promo.promoCode}',
                                  ),
                                  Text(
                                    'Valid: ${formatDate(promo.startDate)} to ${formatDate(promo.endDate)}',
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: promo.isApplied ? Colors.red : const Color.fromARGB(225, 255, 180, 56),
                                ),
                                onPressed: () => _togglePromotion(index),
                                child: Text(promo.isApplied ? 'Remove' : 'Apply'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _createPromotion() {
    // Validate inputs
    if (_promoNameController.text.isEmpty ||
        _discountAmountController.text.isEmpty ||
        _promoCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Set loading state to true
    setState(() {
      _loading = true;
    });

    // Simulate processing delay
    Future.delayed(const Duration(seconds: 2), () {
      // Create new promotion
      final newPromo = Promotion(
        name: _promoNameController.text,
        description: _promoDescriptionController.text,
        discountAmount: double.parse(_discountAmountController.text),
        discountType: _discountType,
        promoCode: _promoCodeController.text,
        startDate: _startDate,
        endDate: _endDate,
        image: _selectedImage, // Add the selected image
        isApplied: false,
      );

      // Add to list and clear form
      setState(() {
        _promotions.add(newPromo);
        _promoNameController.clear();
        _promoDescriptionController.clear();
        _discountAmountController.clear();
        _promoCodeController.clear();
        _selectedImage = null; // Clear the selected image
        _loading = false; // Set loading state back to false
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promotion created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _togglePromotion(int index) {
    setState(() {
      _promotions[index].isApplied = !_promotions[index].isApplied;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _promotions[index].isApplied
              ? 'Promotion applied successfully'
              : 'Promotion removed',
        ),
        backgroundColor: _promotions[index].isApplied ? Colors.green : Colors.orange,
      ),
    );
  }
}

// Updated model class for promotions
class Promotion {
  final String name;
  final String description;
  final double discountAmount;
  final String discountType;
  final String promoCode;
  final DateTime startDate;
  final DateTime endDate;
  final File? image; // Add image property
  bool isApplied;

  Promotion({
    required this.name,
    required this.description,
    required this.discountAmount,
    required this.discountType,
    required this.promoCode,
    required this.startDate,
    required this.endDate,
    this.image,
    this.isApplied = false,
  });
}
