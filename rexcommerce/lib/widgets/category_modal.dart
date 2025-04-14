import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/app_provider.dart';

enum Category {
  textbook,
  electronics,
  furniture,
  clothing,
  school,
  other,
  None
}

class CategoryModal extends StatelessWidget {

                 // or FRadioSelectGroupController()
  final FMultiSelectGroupController<Category> controller  = FMultiSelectGroupController();
  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
          content: Column(
        children: [
          FSelectTileGroup<Category>(

            groupController: controller,
            scrollController: ScrollController(),
            cacheExtent: 100,
            maxHeight: 200,
            // dragStartBehavior: DragStartBehavior.start,
            physics: const ClampingScrollPhysics(),
            label: const Text('Select filter'),
            description: const Text(
                ''),
            divider: FTileDivider.indented,
            children: [
                FSelectTile(
                title: const Text('No Filter'),
                value: Category.None,
              ),
              FSelectTile(
                title: const Text('Electronics'),
                value: Category.electronics,
              ),
              FSelectTile(
                title: const Text('Textbook'),
                value: Category.textbook,
              ),
               FSelectTile(
                title: const Text('Clothing'),
                value: Category.clothing,
              ),
               FSelectTile(
                title: const Text('Furniture'),
                value: Category.furniture,
              ),
               FSelectTile(
                title: const Text('School Supplies'),
                value: Category.school,
              ),
               FSelectTile(
                title: const Text('Other'),
                value: Category.other,
              ),
             
            ],
          ),
          FButton(onPress: () async{

            String category = "";
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
                          } else {
                            category = "None";
                          }
                        }
                          
                          print("Selected category: $category");
              Provider.of<AppProvider>(context,listen:false).filterProducts(query: "", category: category);
              Navigator.pop(context);
          }, label: Text("Apply"))
        ],
      )),
    );
  }
}
