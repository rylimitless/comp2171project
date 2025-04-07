import 'package:flutter/material.dart';
import 'dart:async';
import 'sideBar.dart'; // Import the sidebar

class BiddingPage extends StatefulWidget {
  const BiddingPage({super.key});

  @override
  _BiddingPageState createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage> {
  // Sample data - in a real app, this would come from a database or API
  List<BidItem> bidItems = [
    BidItem(
      id: '1',
      name: 'Vintage Watch',
      description: 'A beautiful vintage watch from the 1950s',
      imageUrl: 'https://example.com/watch.jpg',
      currentBid: 150.0,
      startingBid: 100.0,
      endTime: DateTime.now().add(const Duration(days: 2)),
      highestBidder: 'user123',
    ),
    BidItem(
      id: '2',
      name: 'Art Painting',
      description: 'Original oil painting by local artist',
      imageUrl: 'https://example.com/painting.jpg',
      currentBid: 300.0,
      startingBid: 200.0,
      endTime: DateTime.now().add(const Duration(days: 1)),
      highestBidder: 'user456',
    ),
    BidItem(
      id: '3',
      name: 'Antique Furniture',
      description: 'Handcrafted wooden cabinet from 19th century',
      imageUrl: 'https://example.com/furniture.jpg',
      currentBid: 500.0,
      startingBid: 400.0,
      endTime: DateTime.now().add(const Duration(hours: 12)),
      highestBidder: 'user789',
    ),
  ];
  
  // Current user ID - in a real app, this would come from auth
  final String currentUserId = 'user123';
  
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    // Update the UI every second to refresh auction states
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bidding Items'),
        backgroundColor: const Color.fromARGB(225, 180, 56, 180),
      ),
      drawer: const SideBar(), // Add the sidebar as a drawer
      body: bidItems.isEmpty
          ? const Center(child: Text('No items available for bidding'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: bidItems.length,
              itemBuilder: (context, index) {
                return BidItemCard(
                  bidItem: bidItems[index],
                  currentUserId: currentUserId,
                  onBidPlaced: (item, amount) {
                    _placeBid(item, amount);
                  },
                );
              },
            ),
    );
  }
  
  void _placeBid(BidItem item, double amount) {
    // Validate bid amount
    if (amount <= item.currentBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bid must be higher than current bid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Update bid (in a real app, this would be a API call)
    setState(() {
      final index = bidItems.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        bidItems[index].currentBid = amount;
        bidItems[index].highestBidder = currentUserId;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bid placed successfully for ${item.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }
}

class BidItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  double currentBid;
  final double startingBid;
  final DateTime endTime;
  String highestBidder;
  
  BidItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.currentBid,
    required this.startingBid,
    required this.endTime,
    required this.highestBidder,
  });
  
  bool get isEnded => DateTime.now().isAfter(endTime);
  
  Duration get timeRemaining => endTime.difference(DateTime.now());
}

class BidItemCard extends StatefulWidget {
  final BidItem bidItem;
  final String currentUserId;
  final Function(BidItem, double) onBidPlaced;
  
  const BidItemCard({
    super.key,
    required this.bidItem,
    required this.currentUserId,
    required this.onBidPlaced,
  });

  @override
  _BidItemCardState createState() => _BidItemCardState();
}

class _BidItemCardState extends State<BidItemCard> {
  final _bidController = TextEditingController();
  
  String get _bidStatus {
    if (widget.bidItem.isEnded) {
      return widget.bidItem.highestBidder == widget.currentUserId
          ? "You won this auction!"
          : "Auction ended";
    } else {
      return widget.bidItem.highestBidder == widget.currentUserId
          ? "You're the highest bidder"
          : "You've been outbid";
    }
  }
  
  Color get _statusColor {
    if (widget.bidItem.isEnded) {
      return widget.bidItem.highestBidder == widget.currentUserId
          ? Colors.green
          : Colors.grey;
    } else {
      return widget.bidItem.highestBidder == widget.currentUserId
          ? Colors.green
          : Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with consistent sizing (matching MyListings)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: widget.bidItem.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.bidItem.imageUrl,
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
                                color: const Color.fromARGB(225, 180, 56, 180),
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / 
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(Icons.image, size: 30, color: Colors.grey[600]),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Item details
            Text(
              widget.bidItem.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(widget.bidItem.description),
            const SizedBox(height: 12),
            
            // Bid information
            Text('Current Bid: \$${widget.bidItem.currentBid.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Bid status
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _bidStatus,
                style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            // Bid placement
            if (!widget.bidItem.isEnded)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _bidController,
                      decoration: InputDecoration(
                        labelText: 'Your Bid (\$)',
                        hintText: 'Enter amount higher than ${widget.bidItem.currentBid}',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_bidController.text.isNotEmpty) {
                        double amount = double.tryParse(_bidController.text) ?? 0;
                        widget.onBidPlaced(widget.bidItem, amount);
                        _bidController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 180, 56, 180),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Place Bid'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }
}