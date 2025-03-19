import 'package:flutter/material.dart';
import 'package:rexcommerce/sideBar.dart'; // Import the sidebar widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rex Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListingsScreen(),
    );
  }
}

class Listing {
  final String title;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final String? meetupLocation; // Added meetupLocation field

  Listing({
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.meetupLocation, // Optional parameter
  });
}

class ListingsScreen extends StatefulWidget {
  @override
  _ListingsScreenState createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final List<Listing> _listings = [
    Listing(
      title: "Smartphone X",
      category: "Electronics",
      price: 599.99,
      imageUrl: "https://images.unsplash.com/photo-1523206489230-c012c64b2b48?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "A high-end smartphone with a 6.5-inch OLED display and 128GB storage.",
      meetupLocation: "UWI Student Union Building",
    ),
    Listing(
      title: "Men's Casual Shirt",
      category: "Clothing",
      price: 29.99,
      imageUrl: "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Comfortable and stylish casual shirt for men.",
      meetupLocation: "Faculty of Science & Technology",
    ),
    Listing(
      title: "Programming Book",
      category: "Textbooks",
      price: 49.99,
      imageUrl: "https://images.unsplash.com/photo-1495446815901-a7297e633e8d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Learn programming with this comprehensive guide.",
      meetupLocation: "Main Library",
    ),
    Listing(
      title: "Wireless Headphones",
      category: "Electronics",
      price: 99.99,
      imageUrl: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Noise-cancelling wireless headphones with 20-hour battery life.",
      meetupLocation: "Computing Department",
    ),
    Listing(
      title: "Women's Summer Dress",
      category: "Clothing",
      price: 39.99,
      imageUrl: "https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Lightweight and breathable summer dress for women.",
      meetupLocation: "Social Sciences Building",
    ),
    Listing(
      title: "Cookbook",
      category: "Miscellaneous",
      price: 19.99,
      imageUrl: "https://images.unsplash.com/photo-1543002588-bfa74002ed7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "A collection of delicious recipes from around the world.",
      meetupLocation: "UWI Visitor's Lodge",
    ),
    Listing(
      title: "Laptop Stand",
      category: "Miscellaneous",
      price: 35.99,
      imageUrl: "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Ergonomic laptop stand for better posture.",
      meetupLocation: "Engineering Building",
    ),
    Listing(
      title: "Math Textbook",
      category: "Textbooks",
      price: 59.99,
      imageUrl: "https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Advanced mathematics textbook for university students.",
      meetupLocation: "Mathematics Department",
    ),
    Listing(
      title: "Winter Jacket",
      category: "Clothing",
      price: 89.99,
      imageUrl: "https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Warm and durable winter jacket for cold weather.",
      meetupLocation: "UWI Bookshop",
    ),
    Listing(
      title: "Desk Organizer",
      category: "Miscellaneous",
      price: 24.99,
      imageUrl: "https://images.unsplash.com/photo-1585637071663-799845ad5212?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Compact desk organizer for your workspace.",
      meetupLocation: "Faculty of Humanities",
    ),
    Listing(
      title: "Physics Textbook",
      category: "Textbooks",
      price: 69.99,
      imageUrl: "https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      description: "Comprehensive physics textbook for advanced learners.",
      meetupLocation: "Physics Department",
    ),
  ];

  String _searchQuery = "";
  String? _selectedCategory = "All";
  String? _selectedPriceRange;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<Listing> get filteredListings {
    return _listings.where((listing) {
      final matchesSearch =
          listing.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "All" || listing.category == _selectedCategory;
      final matchesPrice = _selectedPriceRange == null ||
          _isPriceInRange(listing.price, _selectedPriceRange!);
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }

  bool _isPriceInRange(double price, String range) {
    switch (range) {
      case "Under \$25":
        return price < 25;
      case "\$25 - \$50":
        return price >= 25 && price <= 50;
      case "\$50 - \$100":
        return price >= 50 && price <= 100;
      case "Over \$100":
        return price > 100;
      default:
        return true;
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1; // Reset to first page when searching
    });
  }

  void _updateCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _currentPage = 1; // Reset to first page when changing category
    });
  }

  void _updatePriceRange(String? range) {
    setState(() {
      _selectedPriceRange = range;
      _currentPage = 1; // Reset to first page when changing price range
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredListings;
    final totalPages = (filtered.length / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final paginatedListings = filtered.sublist(
      startIndex,
      endIndex < filtered.length ? endIndex : filtered.length,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Listings")),
      // Add sidebar as drawer
      drawer: const SideBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _updateSearchQuery,
            ),
            const SizedBox(height: 16),

            // Filters Row - improved layout
            Row(
              children: [
                // Category Filter
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: Text("Category"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        items: ["All", "Textbooks", "Clothing", "Electronics", "Miscellaneous"].map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: _updateCategory,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Price Range Filter
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPriceRange,
                        hint: Text("Price Range"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        items: [
                          "Under \$25",
                          "\$25 - \$50",
                          "\$50 - \$100",
                          "Over \$100",
                        ].map((String range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                        onChanged: _updatePriceRange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid of Listings with optimized card design
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9, // Increased from 0.75 to reduce vertical space
              ),
              itemCount: paginatedListings.length,
              itemBuilder: (context, index) {
                final listing = paginatedListings[index];
                return GestureDetector(
                  onTap: () => _showProductDetails(context, listing),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with rounded top corners
                        Expanded(
                          flex: 4, // Increased from 3 to give more prominence to image
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              listing.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        // Item details with more compact layout
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                listing.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 12
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Price and category on same row to save space
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${listing.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        _getCategoryIcon(listing.category),
                                        size: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        listing.category,
                                        style: TextStyle(
                                          fontSize: 9, 
                                          color: Colors.grey.shade600
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Pagination with rounded button styling
            if (totalPages > 0)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 20),
                        onPressed: _currentPage > 1
                            ? () => _goToPage(_currentPage - 1)
                            : null,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Text(
                        "Page $_currentPage of $totalPages",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, size: 20),
                        onPressed: _currentPage < totalPages
                            ? () => _goToPage(_currentPage + 1)
                            : null,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Method to display product details in a popup overlay
  void _showProductDetails(BuildContext context, Listing listing) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Divider(),
                // Content scrollable area
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            listing.imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Product title
                        Text(
                          listing.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        // Price and category
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${listing.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Chip(
                              label: Text(listing.category),
                              backgroundColor: Colors.blue.shade50,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          listing.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Meetup Location - Added section
                        if (listing.meetupLocation != null) ...[
                          Text(
                            'Meetup Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Card(
                            elevation: 2,
                            color: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      listing.meetupLocation!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 24),
                        
                        // Contact button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.message),
                            label: Text('Contact Seller'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Contacting seller...')),
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Helper method to get appropriate icon for each category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Textbooks":
        return Icons.book;
      case "Clothing":
        return Icons.checkroom;
      case "Electronics":
        return Icons.devices;
      case "Miscellaneous":
        return Icons.category;
      default:
        return Icons.sell;
    }
  }
}