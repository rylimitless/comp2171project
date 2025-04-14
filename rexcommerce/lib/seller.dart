import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:toastification/toastification.dart';

int pageIndex = 0;

enum Category {
  textbook,
  electronics,
  furniture,
  clothing,
  school,
  other,
  None
}

enum Condition { New, Used, Good, Poor, None }

String prodName = "";
String url = "";
String category = "";
String description = "";
double price = 0.0;
bool isProductBidding = false;
String prodCondition = "";
String seller_name = "";
String seller_id = "";
String name = "";
bool isUrlValid = true;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _categoryIdController =
      TextEditingController(); // Consider using a dropdown later
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _conditionController =
      TextEditingController(); // Consider using a dropdown/radio buttons

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _categoryIdController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  Future<void> _submitProduct(AppProvider app) async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text;
        final url = _urlController.text;
        final categoryId = _categoryIdController.text;
        final description = _descriptionController.text;
        final price = double.tryParse(_priceController.text);
        final condition = _conditionController.text;

        if (price == null) {
          // Handle invalid price input
          toastification.show(
            context: context,
            title: const Text('Invalid Price'),
            description:
                const Text('Please enter a valid number for the price.'),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            autoCloseDuration: const Duration(seconds: 5),
          );
          return;
        }

        // Assuming AppProvider has the logged-in user's ID
        final sellerId = app.userdata.record.id;
        // Call a method in AppProvider to add the product
        await app.addProduct(
          name: name,
          url: url,
          categoryId: categoryId,
          description: description,
          price: price,
          condition: condition,
          sellerId: sellerId,
        );

        toastification.show(
          context: context,
          title: const Text('Success'),
          description: const Text('Product added successfully!'),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
        );

        // Optionally clear the form or navigate away
        _formKey.currentState?.reset();
        _nameController.clear();
        _urlController.clear();
        _categoryIdController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _conditionController.clear();
        // Consider Navigator.pop(context);
      } catch (e, stackTrace) {
        Logger().e('Error adding product: $e', stackTrace: stackTrace);
        toastification.show(
          context: context,
          title: const Text('Error'),
          description: Text('Failed to add product: ${e.toString()}'),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 7),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>(); // Get AppProvider instance
    return FTheme(
      data: FThemes.zinc.light, // Or your preferred theme
      child: FScaffold(
        header: FHeader(
          title: Text(
            'Add New Product',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            FTappable.animated(
              semanticLabel: 'Label',
              semanticSelected: false,
              excludeSemantics: false,
              builder: (context, state, child) => child!,
              focusNode: FocusNode(),
              onFocusChange: (focused) {},
              touchHoverEnterDuration: const Duration(milliseconds: 200),
              touchHoverExitDuration: Duration.zero,
              behavior: HitTestBehavior.translucent,
              onPress: () async {
                // await app.GetProducts();
                // Reset all data
                prodName = "";
                url = "";
                category = "";
                description = "";
                price = 0.0;
                isProductBidding = false;
                prodCondition = "";
                isUrlValid = true;

                // Reset page index
                Provider.of<AppProvider>(context, listen: false).changeIndex(0);

                // Navigate back
              },
              child: FIcon(FAssets.icons.x),
            )
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: IndexedStack(
                index: app.productPageindex,
                children: [
                  Section1(),
                  Section2(),
                  Section3(),
                ],
              )),
        ),
      ),
    );
  }
}

//First Section -- Name , Description , condition

class Section1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Section1();
  }
}

class _Section1 extends State<Section1> {
  final _section1Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FTheme(
          data: FThemes.zinc.light,
          child: Form(
            key: _section1Key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FTextField(
                  label: Text("Enter Product Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a product name";
                    }
                    if (value.length > 20) {
                      return "Product name Too long";
                    }

                    prodName = value;
                    print(prodName);
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                FTextField(
                  validator: (value) {
                    description = value ??= "";
                    return null;
                  },
                  label: Row(
                    children: [
                      Text("Enter Product Description"),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "(optional)",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 20,
                ),
                FTextField(
                  onChange: (value) => description = value,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return "Enter a valid url";
                    }

                    url = value;
                    return null;
                  },
                  label: Row(
                    children: [
                      Text("Enter Image url"),
                    ],
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 40,
                ),
                FButton(
                    onPress: () {
                      if (_section1Key.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        setState(() {
                          Provider.of<AppProvider>(context, listen: false)
                              .changeIndex(1);
                        });
                      }
                    },
                    label: Text("Next"))
              ],
            ),
          )),
    );
  }
}

//Section 2 -- category , price

class Section2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Section2();
  }
}

class _Section2 extends State<Section2> {
  final _section2Key = GlobalKey<FormState>();
  final FRadioSelectGroupController<Category> controller =
      FRadioSelectGroupController();
  final FRadioSelectGroupController<Condition> controller2 =
      FRadioSelectGroupController();
  bool isBidding = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FTheme(
          data: FThemes.zinc.light,
          child: Form(
            key: _section2Key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !isBidding,
                  child: FTextField(
                    label: Text("Enter Product Price"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a product price name";
                      }

                      if (double.tryParse(value) != null &&
                          double.tryParse(value)! > 10000) {
                        return "Item price cannot be greater than \$10000";
                      }

                      final val = double.tryParse(value);
                      price = val!;
                      return null;
                    },
                  ),
                ),
                FSwitch(
                  label: const Text('Bids Only'),
                  semanticLabel: 'Bidding Item',
                  value: isBidding,
                  onChange: (value) => setState(() {
                    isBidding = value;
                    isProductBidding = isBidding;
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                FSelectTileGroup(
                  groupController: controller,
                  label: const Text('Category'),
                  description: const Text('Select product category.'),
                  validator: (values) =>
                      values?.isEmpty ?? true ? 'Please select a value.' : null,
                  children: [
                    FSelectTile(
                      title: const Text('Electronics'),
                      value: Category.electronics,
                    ),
                    FSelectTile(
                        title: const Text('Textbook'),
                        value: Category.textbook),
                    FSelectTile(
                        title: Text('Clothing'), value: Category.clothing),
                    FSelectTile(title: Text('School'), value: Category.school),
                    FSelectTile(
                      title: const Text('Other'),
                      value: Category.other,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                FSelectTileGroup(
                  groupController: controller2,
                  label: const Text('Condition'),
                  description: const Text('Select product condition.'),
                  validator: (values) =>
                      values?.isEmpty ?? true ? 'Please select a value.' : null,
                  children: [
                    FSelectTile(title: const Text('New'), value: Condition.New),
                    FSelectTile(
                        title: const Text('Used'), value: Condition.Used),
                    FSelectTile(title: Text('Good'), value: Condition.Good),
                    FSelectTile(title: Text('Poor'), value: Condition.Poor),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                FButton(
                  prefix: FIcon(FAssets.icons.arrowLeft),
                  onPress: () {
                    Provider.of<AppProvider>(context, listen: false)
                        .changeIndex(0);
                  },
                  label: Text('Previous'),
                ),
                SizedBox(
                  height: 10,
                ),
                FButton(
                    suffix: FIcon(FAssets.icons.arrowRight),
                    onPress: () {
                      if (_section2Key.currentState!.validate()) {
                        final Set<Category> c = controller.value;
                        if (c.isNotEmpty) {
                          if (c.contains(Category.clothing)) {
                            category = "Clothing";
                          } else if (c.contains(Category.electronics)) {
                            category = "Electronics";
                          } else if (c.contains(Category.textbook)) {
                            category = "Textbook";
                          } else if (c.contains(Category.school)) {
                            category = "School";
                          } else if (c.contains(Category.other)) {
                            category = "Other";
                          }

                          print("Selected category: $category");
                        }

                        final Set<Condition> condSet = controller2.value;
                        if (condSet.isNotEmpty) {
                          if (condSet.contains(Condition.New)) {
                            prodCondition = "New";
                          } else if (condSet.contains(Condition.Used)) {
                            prodCondition = "Used";
                          } else if (condSet.contains(Condition.Good)) {
                            prodCondition = "Good";
                          } else if (condSet.contains(Condition.Poor)) {
                            prodCondition = "Poor";
                          }
                        }

                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        setState(() {
                          Provider.of<AppProvider>(context, listen: false)
                              .changeIndex(2);
                        });
                      }
                    },
                    label: Text("Next"))
              ],
            ),
          )),
    );
  }
}

class Section3 extends StatefulWidget {
  @override
  State<Section3> createState() {
    return _Section3();
  }
}

//Preview

class _Section3 extends State<Section3> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FTheme(
          data: FThemes.zinc.light,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Preview",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                // Center the image/placeholder
                child: Container(
                  height: 150, // Give the image container a fixed height
                  width: double.infinity, // Make it take the available width
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[200], // Background color for placeholder area
                    borderRadius:
                        BorderRadius.circular(8), // Optional: rounded corners
                  ),
                  child: isUrlValid
                      ? Image.network(
                          url,
                          fit: BoxFit.cover, // Cover the container bounds
                          // Optional: Add loading indicator
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          // Error handling for failed image load
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            // Log the error if needed: Logger().e("Image Load Error: $exception");
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey[600]),
                                  SizedBox(height: 8),
                                  Text('Image unavailable',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          // Display placeholder if URL is invalid
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported,
                                  size: 40, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text('Invalid image URL',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FTextField(
                readOnly: true,
                label: Text("Product Name"),
                hint: prodName,
              ),
              SizedBox(
                height: 20,
              ),
              FTextField(
                readOnly: true,
                label: Text("Product Description"),
                hint: description.isNotEmpty
                    ? description
                    : '(No description provided)', // Show placeholder if empty
                maxLines: 3, // Allow multiple lines for description preview
              ),
              SizedBox(
                height: 20,
              ),
              FTextField(
                readOnly: true,
                label: Text("Product Category"),
                hint: category,
                maxLength: 1,
              ),
              SizedBox(
                height: 20,
              ),
              FTextField(
                readOnly: true,
                label: Text("Product Condition"),
                hint: prodCondition,
                maxLength: 1,
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: true,
                child: FTextField(
                  readOnly: true,
                  label: Text("Price"),
                  hint: isProductBidding ? 'Bidding' : '\$$price',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FButton(
                prefix: FIcon(FAssets.icons.arrowLeft),
                onPress: () {
                  Provider.of<AppProvider>(context, listen: false)
                      .changeIndex(1);
                },
                label: Text('Previous'),
              ),
              SizedBox(
                height: 10,
              ),
              FButton(
                  suffix: FIcon(FAssets.icons.arrowUp),
                  onPress: () async {
                    //TODO upload the product

                    final Products prod = Products(prodName, url, "",
                        description, price, prodCondition, "", "");
                    bool success =
                        await Provider.of<AppProvider>(context, listen: false)
                            .createListing(prod, category);
                    if (success) {
                      // Handle invalid price input
                      toastification.show(
                        title: const Text('Item Created Successfully'),
                        type: ToastificationType.success,
                        style: ToastificationStyle.flat,
                        autoCloseDuration: const Duration(seconds: 1),
                      );
                      Provider.of<AppProvider>(context, listen: false)
                              .changeIndex(0);
                      Provider.of<AppProvider>(context,listen: false).sethomeIndex(0);
                    } else {
                      toastification.show(
                        title: const Text('Create Failed'),
                        type: ToastificationType.error,
                        style: ToastificationStyle.flat,
                        autoCloseDuration: const Duration(seconds: 1));
                    } 
                  },
                  label: Text("Create Listing"))
            ],
          )),
    );
  }
}
// Add this method to your AppProvider class in lib/app_provider.dart
/*

*/
