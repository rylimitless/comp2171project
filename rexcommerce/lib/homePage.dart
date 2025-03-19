import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rexcommerce/sideBar.dart';
import 'package:rexcommerce/sell_Item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track liked listings
  final Set<String> _likedListings = {};
  
  // Selected category for filtering
  String? _selectedCategory;
  
  // Price range for filtering
  RangeValues _priceRange = const RangeValues(0, 2000);
  
  // Show filter options
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RexCommerce',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Removed the duplicate search icon from here
      ),
      drawer: const SideBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            _buildPromotionalBanners(),
            _buildCategoriesSection(context),
            _buildFeaturedListingsSection(context),
            _buildFeaturesSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateListingScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Sell Item'),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final categories = ['All Categories', 'Textbooks', 'Clothing', 'Electronics', 'Miscellaneous'];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Campus Marketplace',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'What are you looking for?',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Expandable filter options
          if (_showFilters)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Results',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Category dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: _selectedCategory ?? 'All Categories',
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Price range slider
                  Text(
                    'Price Range: \$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                    style: GoogleFonts.poppins(),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}',
                      '\$${_priceRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Apply filter button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Apply filters logic would go here
                        setState(() {
                          _showFilters = false;
                        });
                      },
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildPromoCard(imageUrl: 'assets/images/fashion.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPromoCard(imageUrl: 'assets/images/bid.jpg'),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard({required String imageUrl}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageUrl,
          height: 280,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 280,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {'title': 'Textbooks', 'image': 'https://images.unsplash.com/photo-1532012197267-da84d127e765'},
      {'title': 'Clothing', 'image': 'https://images.unsplash.com/photo-1445205170230-053b83016050'},
      {'title': 'Electronics', 'image': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03'},
      {'title': 'Miscellaneous', 'image': 'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse Categories',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: categories.map((category) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildCategoryCard(category['title']!, category['image']!),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 100,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedListingsSection(BuildContext context) {
    // Using dummy data that would later be populated dynamically
    final featuredListings = [
      {
        'id': 'listing1', 
        'title': 'MacBook Pro 2023', 
        'price': 1200, 
        'image': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
        'address': 'Faculty of Science & Technology',
        'seller': 'John Doe',
        'rating': 4.8
      },
      {
        'id': 'listing2', 
        'title': 'Calculus Textbook', 
        'price': 45, 
        'image': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
        'address': 'UWI Bookshop',
        'seller': 'Jane Smith',
        'rating': 4.5
      },
      {
        'id': 'listing3', 
        'title': 'Wireless Headphones', 
        'price': 75, 
        'image': 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
        'address': 'Engineering Building',
        'seller': 'Mike Johnson',
        'rating': 4.6
      },
      {
        'id': 'listing4', 
        'title': 'Gaming Mouse', 
        'price': 40, 
        'image': 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7',
        'address': 'Computing Department',
        'seller': 'Sarah Williams',
        'rating': 4.7
      },
      // Updated mock data entries with reliable image URLs
      {
        'id': 'listing5', 
        'title': 'Mountain Bike', 
        'price': 350, 
        'image': 'https://images.unsplash.com/photo-1485965120184-e220f721d03e',
        'address': 'Sports Complex',
        'seller': 'Alex Turner',
        'rating': 4.9
      },
      {
        'id': 'listing6', 
        'title': 'Psychology Textbook', 
        'price': 55, 
        'image': 'https://images.unsplash.com/photo-1532012197267-da84d127e765',
        'address': 'Social Sciences Building',
        'seller': 'Emma Watson',
        'rating': 4.3
      },
      {
        'id': 'listing7', 
        'title': 'Desk Lamp', 
        'price': 25, 
        'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c',
        'address': 'Student Housing',
        'seller': 'David Chen',
        'rating': 4.4
      },
      // Three additional product listings
      {
        'id': 'listing8', 
        'title': 'Scientific Calculator', 
        'price': 35, 
        'image': 'https://images.unsplash.com/photo-1564466809058-bf4114d55352',
        'address': 'Mathematics Department',
        'seller': 'Lisa Johnson',
        'rating': 4.2
      },
      {
        'id': 'listing9', 
        'title': 'Dorm Room Chair', 
        'price': 65, 
        'image': 'https://images.unsplash.com/photo-1519947486511-46149fa0a254',
        'address': 'Taylor Hall',
        'seller': 'Marcus Green',
        'rating': 4.6
      },
      {
        'id': 'listing10', 
        'title': 'Chemistry Lab Kit', 
        'price': 120, 
        'image': 'https://images.unsplash.com/photo-1603126857599-f6e157fa2fe6',
        'address': 'Chemistry Building',
        'seller': 'Tasha Rodriguez',
        'rating': 4.8
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Featured Listings', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 320, // Increased height to accommodate additional details
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredListings.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.2, // 20% of screen width
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildListingCard(featuredListings[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    final bool isLiked = _likedListings.contains(listing['id']);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with like button overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: listing['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        setState(() {
                          if (isLiked) {
                            _likedListings.remove(listing['id']);
                          } else {
                            _likedListings.add(listing['id']);
                          }
                        });
                      },
                      child: Center(
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
            child: Text(
              listing['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          
          // Price
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 4.0),
            child: Text(
              '\$${listing['price']}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          
          // Address
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 4.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    listing['address'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Seller details
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  listing['seller'],
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                const Spacer(),
                Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  listing['rating'].toString(),
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Features',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFeatureCard(
                icon: Icons.verified_user,
                title: 'Verified Sellers',
                description: 'All sellers are verified UWI students or staff',
              ),
              const SizedBox(width: 16),
              _buildFeatureCard(
                icon: Icons.local_offer,
                title: 'Great Deal',
                description: 'Find amazing deals from fellow students',
              ),
              const SizedBox(width: 16),
              _buildFeatureCard(
                icon: Icons.people,
                title: 'Community',
                description: 'Connect with your campus community',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}