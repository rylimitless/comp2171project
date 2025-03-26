import 'package:flutter/material.dart';
import 'sideBar.dart'; // Import the SideBar

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  _MyListingsScreenState createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  List<Map<String, dynamic>> myListings = [
    {
      'id': '1',
      'title': 'Gaming Laptop',
      'price': 1200,
      'status': 'available',
      'imageUrl': 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1468&q=80',
      'createdAt': DateTime.now().subtract(Duration(days: 2))
    },
    {
      'id': '2',
      'title': 'Smartphone',
      'price': 600,
      'status': 'sold',
      'imageUrl': 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1527&q=80',
      'createdAt': DateTime.now().subtract(Duration(hours: 5))
    },
  ];

  void handleDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Listing'),
        content: Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                myListings.removeWhere((listing) => listing['id'] == id);
              });
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void handleStatusChange(String id, String status) {
    setState(() {
      final listing = myListings.firstWhere((listing) => listing['id'] == id);
      listing['status'] = status;
    });
  }

  String timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else {
      return '${difference.inMinutes} minute(s) ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Listings')),
      drawer: SideBar(), // Add the SideBar as a drawer
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: myListings.isEmpty
                  ? Center(child: Text("You haven't created any listings yet."))
                  : ListView.builder(
                      itemCount: myListings.length,
                      itemBuilder: (context, index) {
                        final listing = myListings[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      listing['imageUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[100],
                                          child: Center(child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey[400])),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey[100],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.pinkAccent,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / 
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listing['title'],
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text('\$${listing['price']}',
                                          style: TextStyle(
                                              fontSize: 15, 
                                              fontWeight: FontWeight.w500,
                                              color: Colors.pinkAccent)),
                                      SizedBox(height: 4),
                                      Text('Posted ${timeAgo(listing['createdAt'])}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: listing['status'] == 'available' 
                                                  ? Colors.green[50] 
                                                  : listing['status'] == 'sold' 
                                                      ? Colors.blue[50] 
                                                      : Colors.grey[50],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: DropdownButton<String>(
                                              value: listing['status'],
                                              underline: SizedBox(),
                                              icon: Icon(Icons.arrow_drop_down, size: 18),
                                              isDense: true,
                                              items: [
                                                DropdownMenuItem(value: 'available', child: Text('Available')),
                                                DropdownMenuItem(value: 'sold', child: Text('Sold')),
                                                DropdownMenuItem(value: 'removed', child: Text('Removed')),
                                              ],
                                              onChanged: (value) => handleStatusChange(listing['id'], value!),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                                constraints: BoxConstraints(),
                                                padding: EdgeInsets.all(8),
                                                onPressed: () {},
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                                constraints: BoxConstraints(),
                                                padding: EdgeInsets.all(8),
                                                onPressed: () => handleDelete(listing['id']),
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
            ),
          ],
        ),
      ),
    );
  }
}