import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:toastification/toastification.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _categoryIdController = TextEditingController(); // Consider using a dropdown later
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _conditionController = TextEditingController(); // Consider using a dropdown/radio buttons

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
            description: const Text('Please enter a valid number for the price.'),
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
        header: const FHeader(
          title: Text('Add New Product',
          style: TextStyle(
            fontSize: 15
          ),
          ),
        ),
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: IndexedStack(

              children: [
                Section1()
              ],
            )
          ),
        ),
      ),
    );
  }
}

//First Section -- Name , Description , condition


class Section1 extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _Section1();
  }
}
class _Section1 extends State<Section1>{

  final _section1Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FTheme(
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
              if(value!.isEmpty){
                return "Enter a product name";
              }
              return null;
            },
            
          ),
          SizedBox(height: 20,),
           FTextField(
            label: Text("Enter Product Description"),
            maxLines: 3,
          ),
          SizedBox(height: 40,),
          FButton(onPress: (){}, label: Text("Next"))
      
      ],),
    )
    );
  }
}

// Add this method to your AppProvider class in lib/app_provider.dart
/*

*/