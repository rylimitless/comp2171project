import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Export the necessary classes
export 'productDetails.dart' show ListingDetails, Listing, Seller, Location;

class ListingDetails extends StatelessWidget {
  final String id; // The ID of the listing
  final Listing listing; // The listing data
  final bool showBackButton;

  // Add a constructor that makes the back button optional
  ListingDetails({
    required this.id, 
    required this.listing,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (listing.id != id) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AlertDialog(
            title: Text('Listing Not Found'),
            content: Text('This listing may have been removed or doesn\'t exist.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Return to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Details'),
        automaticallyImplyLeading: showBackButton,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image Gallery
            Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(listing.images[0]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 16),
            // Additional Images (Grid)
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: listing.images.length - 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      listing.images[index + 1],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            // Listing Details
            Text(
              listing.title,
              style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(listing.seller.profileImage),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listing.seller.name),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text(listing.seller.rating.toString()),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Text('\$${listing.price}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            // Description
            Text('Description', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(listing.description),
            SizedBox(height: 16),
            // Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Category'),
                    Chip(label: Text(listing.category)),
                  ],
                ),
                Column(
                  children: [
                    Text('Condition'),
                    Chip(label: Text(listing.condition)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Meetup Location
            Text('Meetup Location', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.grey),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listing.meetupLocation.name),
                        Text(listing.meetupLocation.description),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Actions
            if (listing.isBarter) ...[
              AlertDialog(
                title: Text('Info'),
                content: Text('This item is available for barter'),
                actions: [
                  TextButton(onPressed: () {}, child: Text('Got it')),
                ],
              ),
            ],
            if (listing.seller.id != 'user_id') ...[
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.message),
                label: Text('Message Seller'),
              ),
            ],
            SizedBox(height: 16),
            // Time Posted
            Text(
              'Posted ${formatDistanceToNow(listing.createdAt)} ago',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String formatDistanceToNow(String createdAt) {
    final createdTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(createdTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return 'Just now';
    }
  }
}

class Listing {
  final String id;
  final String title;
  final List<String> images;
  final String description;
  final String category;
  final String condition;
  final double price;
  final Seller seller;
  final Location meetupLocation;
  final String createdAt;
  final bool isBarter;

  Listing({
    required this.id,
    required this.title,
    required this.images,
    required this.description,
    required this.category,
    required this.condition,
    required this.price,
    required this.seller,
    required this.meetupLocation,
    required this.createdAt,
    required this.isBarter,
  });
}

class Seller {
  final String id;
  final String name;
  final String profileImage;
  final double rating;

  Seller({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.rating,
  });
}

class Location {
  final String name;
  final String description;

  Location({
    required this.name,
    required this.description,
  });
}
