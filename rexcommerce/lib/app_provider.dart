import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:rexcommerce/seller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:math';
import 'dart:convert';


class Category {
  String name;
  String url;

  Category(this.name, this.url);
}

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class Products {
  String name;
  String url;
  double price;
  String description;
  String category_id;
  String condition;
  String seller_name;
  String seller_id;

  Products(this.name, this.url, this.category_id, this.description, this.price,
      this.condition, this.seller_name, this.seller_id);
}


class Add {
  String name;
  String description;
  String url;

  Add(this.name,this.description,this.url);
  
}
class AppProvider extends ChangeNotifier {

   final List<types.Message> messages = [];

  final Map<String, String> category_ids = {
  "Other": "e31l3m744b55w0x",
  "Clothing": "p5b0m4qo3q44etp",
  "Furniture": "2jffzmktl59hb48",
  "Electronics": "p4fepgx2uz45027",
  "Textbook": "s52072ls2j8p813",
  "School": "i4m0bs1mlf82go8",
  "All Listings" : ""
};

//  final Map<String, String> category_names = {
//   "e31l3m744b55w0x": "Other",
//   "p5b0m4qo3q44etp": "Clothing",
//   "2jffzmktl59hb48",: "Firni"
//   "Electronics": "p4fepgx2uz45027",
//   "Textbook": "s52072ls2j8p813",
//   "School": "i4m0bs1mlf82go8",
//   "All Listings" : ""
// };

  int homeIndex = 0;
  bool subscribed = false;

  late PocketBase pb;
  late RecordAuth userdata;
  late AuthStore store;
  bool isLoggedIn = false;
  String selectedCategory = "All Listings";

  int productPageindex = 0;

  List<Category> categories = [];
  List<Products> products = [];
  List<Products> featured = [];
  List<Add> ads = [];
  List<Products> allProducts = [];
  

   final _responder = const types.User(id:"10-223");

  late SharedPreferences prefs;

  AppProvider() {
    initApp();
  }

  void sethomeIndex(int index){
    homeIndex = index;
    notifyListeners();
  }

  void changeIndex(int index) {
    productPageindex = index;
    notifyListeners();
  }

  Future<void> updateCategory(String category) async {
      final cat  = category_ids[category];
      print(store.record!.id);
      
//     final post = await pb.collection('users').update('eghd86oa10hbgpo', body: {
      
//     'categories': '$cat',
// });
    // print(post);
  }



  Future<void> GetAds() async {

    // print("ads");

    ads.clear();

    final records = await pb.collection('promo').getFullList(
  filter: 'approved = True',
);

    for (var record in records) {
      final name = record.getStringValue('Name');
      final description = record.getStringValue('Description');
      final url = record.getStringValue('img');

      final ad = Add(name, description, url);
      ads.add(ad);
      // print(ads);
    }

    notifyListeners();
  }

   Future<void> filterProducts({String query = "", String? category}) async {
    List<Products> currentlyFiltered = List.from(allProducts); // Start with all products
    String? categoryId;
    if (category != null && category.isNotEmpty && category != "None") {
      categoryId = category_ids[category];
      selectedCategory = category.isEmpty? "All Listings":category;
      Logger().d("Filtering by category: $category (ID: $categoryId)");
    }
    selectedCategory = category == "None"? "All Listings" : selectedCategory;

    if (categoryId != null && categoryId.isNotEmpty) {
      
      currentlyFiltered = currentlyFiltered.where((product) {
        return product.category_id == categoryId;
      }).toList();
    }

    if (query.isNotEmpty) {
      final lowerCaseQuery = query.toLowerCase();
      currentlyFiltered = currentlyFiltered.where((product) {
        final nameMatch = product.name.toLowerCase().contains(lowerCaseQuery);
        final descriptionMatch = product.description.toLowerCase().contains(lowerCaseQuery);
        return nameMatch || descriptionMatch;
      }).toList();
    }

    Logger().d(currentlyFiltered.length);

    products = currentlyFiltered;

    notifyListeners();
  }

  void subscribe(){
    print("subsribe");
    pb.collection('messages').subscribe('*', (e) {
    print(e.record);

    if(e.record!.id != store.record!.id){
        final textMessage = types.TextMessage(
      author: _responder,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: e.record!.getStringValue("message"),
    );
        messages.insert(0, textMessage);
        notifyListeners();

    }
}, /* other options like: filter, expand, custom headers, etc. */);

  }

  void sendMessage(String message) async{
      final body = <String, dynamic>{
  "message": message,
  "sender": "${store.record!.id}"
};

final record = await pb.collection('messages').create(body: body);
print(record);
  }

  


  Future<void> initApp() async {
    prefs = await SharedPreferences.getInstance();

    store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    pb = PocketBase('http://localhost:8090', authStore: store);

    isLoggedIn = store.isValid;
  }

  Future<void> GetCategories() async {
    final records = await pb.collection('categories').getFullList();

    for (var record in records) {
      final name = record.getStringValue('name');
      final img = record.getStringValue('img');

      final category = Category(name, img);
      categories.add(category);
    }

    notifyListeners();
  }


  // ... existing code ...

Future<void> GetFeaturedProducts() async {
  // Ensure user is logged in and record is available
  if (store.record == null) {
    Logger().w("User record not available for filtering.");
    featured.clear(); // Clear list if user data is missing
    notifyListeners();
    return;
  }

  final userId = store.record!.id;
  final List<String> categoryIds = store.record!.getListValue<String>("categories");

  String filter = 'seller = "$userId"'; // Start with the seller filter
  print(userId);
  if (categoryIds.isNotEmpty) {
    final categoryFilter = categoryIds.map((id) => 'category = "$id"').join(' || ');
    filter += ' && ($categoryFilter)'; // IMPORTANT: Group OR conditions with parentheses
  } else {
 
    Logger().i("No category IDs found for user, fetching all seller's items.");
 
  }

  featured.clear(); 
  try {
    final records = await pb.collection('item').getFullList(
      filter: filter, // Use the dynamically built filter
      expand: 'seller',
    );

    for (var record in records) {
      final seller_name = (record.get<Map>("expand.seller")['name']);
      final seller_id = record.getStringValue('seller'); // This should match userId
      final name = record.getStringValue('title');
      final price = record.getDoubleValue('price');
      final description = record.getStringValue('description');
      final condition = record.getStringValue('condition');
      final url = record.getStringValue('img');
      final category_id = record.getStringValue('category');


      final product = Products(name, url, category_id, description, price,
          condition, seller_name, seller_id);
      featured.add(product); // Add to the 'featured' list
    }
  } catch (e, stackTrace) {
     Logger().e('Error fetching featured products: $e', stackTrace: stackTrace);
     featured.clear();
  } finally {
     notifyListeners(); 
  }
}

// ... rest of AppProvider ...

  Future<void> GetProducts() async {
    print("huhhhhh");

    products.clear();
    allProducts.clear();
    final records = await pb.collection('item').getFullList(
      filter: 'seller="${store.record!.id}"',
      expand: 'seller'
      );

    for (var record in records) {
      final seller_name = (record.get<Map>("expand.seller")['name']);
      final seller_id = record.getStringValue('seller');
      final name = record.getStringValue('title');
      final price = record.getDoubleValue('price');
      final description = record.getStringValue('description');
      final condition = record.getStringValue('condition');
      final url = record.getStringValue('img');
      final category_id = record.getStringValue('category');

      final product = Products(name, url, category_id, description, price,
          condition, seller_name, seller_id);
      allProducts.add(product);
      products = allProducts;
      notifyListeners();
    }
  }

   Future<void> GetMyProducts() async {
    print("Hello");
    products.clear();
    final records = await pb.collection('item').getFullList(
      filter: 'seller="${store.record!.id}"',
      expand: 'seller');

    for (var record in records) {
      final seller_name = (record.get<Map>("expand.seller")['name']);
      final seller_id = record.getStringValue('seller');
      final name = record.getStringValue('title');
      final price = record.getDoubleValue('price');
      final description = record.getStringValue('description');
      final condition = record.getStringValue('condition');
      final url = record.getStringValue('img');
      final category_id = record.getStringValue('category');

      final product = Products(name, url, category_id, description, price,
          condition, seller_name, seller_id);

      products.add(product);

      notifyListeners();
    }
  }


  Future<bool> createListing(Products prod , String category) async {
    Logger().i("Creating ${prod.condition}");

    final body = <String, dynamic>{
      "title": prod.name,
      "description": prod.description,
      "condition": prod.condition,
      "price": prod.price,
      "category": category_ids[category],
      "img": prod.url,
      "seller": store.record!.id,
      "bid_item": false
    };

    try{
    final record = await pb.collection('item').create(body: body);
    print(record);
    return true;

    } catch (e){
      print(e);
      return false;
    }
   
  }

  Future<bool> createAd(String name, String Description,String img , String date) async {

    print("created at");
    final body = <String, dynamic>{
  "Name": name,
  "Description": description,
  "i": "test",
  "img": img,
  "date": date
};


    try{
    final record = await pb.collection('promo').create(body: body);
    print(record);
    return true;

    } catch (e){
      print(e);
      return false;
    }


  }

  Future<bool> login(String username , String password) async {
    try {
      userdata = await pb
          .collection('users')
          .authWithPassword('user1@rexc.con', 'helloworld');
      Logger().e(userdata);

      if (userdata.token.isNotEmpty) {
        Logger().e(userdata);
        return true;
      }
    } catch (e) {
      Logger().e(e);
      return false;
    }

    return false;
  }

  Future<void> addProduct({
    required String name,
    required String url,
    required String categoryId,
    required String description,
    required double price,
    required String condition,
    required String sellerId,
  }) async {
    try {
      final body = <String, dynamic>{
        "title": name,
        "img": url,
        "category_id":
            categoryId, // Ensure this category ID exists in your 'category' collection
        "description": description,
        "price": price,
        "condition": condition,
        "seller": sellerId, // Link to the user record
        "status": "available", // Default status
      };
      final record = await pb.collection('item').create(body: body);
      Logger().i('Product created: ${record.id}');
      // Optionally refresh the product list after adding
      await GetProducts(); // Refresh the list shown in ListingPage
      notifyListeners(); // Notify listeners if GetProducts doesn't already
    } catch (e, stackTrace) {
      Logger().e('Error creating product in PocketBase: $e',
          stackTrace: stackTrace);
      rethrow; // Rethrow to be caught in the UI layer
    }
  }

    void handleSendPressed(types.PartialText message) {
      if(!subscribed){
        subscribed = true;
        subscribe();
      } else {
        sendMessage(message.text);
      }

  const _user =  types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

    if(message.text!=""){
      // print(country);
      //   auth.createMessage(message.text,context,country: country,type: type);
    }
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    addMessage(textMessage);
  }

  void addMessage(types.Message message) {
        messages.insert(0,message);
        notifyListeners();
  }
  
}
