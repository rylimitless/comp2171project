import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:forui/forui.dart';
import 'package:rexcommerce/app_provider.dart'; // Import your Product class definition

class ItemModal extends StatelessWidget {
  final Products product; // Add product field

  // Add constructor to accept product data
  const ItemModal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      // Wrap the content in SingleChildScrollView
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keep this for initial sizing
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FCard(
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${product.price}", // Use actual product data
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      product.condition,
                    ),
                  ],
                ),
                title: Text(
                  product.name, // Use actual product data
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                image: Container(
                  width: double.infinity,
                  height: 150, // Keep or adjust as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          product.url), // Use actual product data URL
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // print("Error loading image in modal: $exception");
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(product.description), // Use actual product data
              SizedBox(height: 16),
              FButton(label: Text("Contact Seller"), onPress: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
