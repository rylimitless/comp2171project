import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  String name;
  String url;

  Category(this.name, this.url);
}

final Map<String, String> category_ids = {
  "Other": "e31l3m744b55w0x",
  "Clothing": "p5b0m4qo3q44etp",
  "Furniture": "2jffzmktl59hb48",
  "Electronics": "p4fepgx2uz45027",
  "Textbook": "s52072ls2j8p813",
  "School": "i4m0bs1mlf82go8",
};

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

class AppProvider extends ChangeNotifier {
  late PocketBase pb;
  late RecordAuth userdata;
  late AuthStore store;
  bool isLoggedIn = false;

  int productPageindex = 0;

  List<Category> categories = [];
  List<Products> products = [];

  late SharedPreferences prefs;

  AppProvider() {
    initApp();
  }

  void changeIndex(int index) {
    productPageindex = index;
    notifyListeners();
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

  Future<void> GetProducts() async {
    final records = await pb.collection('item').getFullList(expand: 'seller');

    for (var record in records) {
      final seller_name = (record.get<Map>("expand.seller")['name']);
      final seller_id = record.getStringValue('seller');
      final name = record.getStringValue('title');
      final price = record.getDoubleValue('price');
      final description = record.getStringValue('description');
      final condition = record.getStringValue('condition');
      final url = record.getStringValue('img');
      final category_id = record.getStringValue('category_id');

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

  Future<bool> login() async {
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
}
