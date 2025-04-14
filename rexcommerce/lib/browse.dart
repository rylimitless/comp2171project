import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:forui/forui.dart';
import 'package:forui/assets.dart';
import 'package:rexcommerce/widgets/chat_modal.dart';
import 'package:rexcommerce/widgets/nav_bar.dart';
import 'package:rexcommerce/widgets/category_modal.dart';
class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  @override
  State<BrowsePage> createState() => _ListingPageState();
}

class _ListingPageState extends State<BrowsePage> {

  @override
  Widget build(BuildContext context) =>
      Consumer<AppProvider>(builder: (context, app, child) {
        return FTheme(
          data: FThemes.zinc.light,
          child: FScaffold(
            header: FHeader(
              title: FTappable.animated(
                    semanticLabel: 'Label',
                    semanticSelected: false,
                    excludeSemantics: false,
                    builder: (context, state, child) => child!,
                    focusNode: FocusNode(),
                    onFocusChange: (focused) {},
                    touchHoverEnterDuration: const Duration(milliseconds: 300),
                    touchHoverExitDuration: Duration.zero,
                    behavior: HitTestBehavior.translucent,
                    onPress: () async{
                        // await app.GetProducts();
                      showFSheet(
                                context: context,
                                side: FLayout.btt,
                                builder: (context) => CategoryModal(),
                              );
                    },
                    child: Text(
                app.selectedCategory,
                style: TextStyle(fontSize: 15),
              ),), 
              
              actions: [
                FTappable.animated(
                    semanticLabel: 'Label',
                    semanticSelected: false,
                    excludeSemantics: false,
                    builder: (context, state, child) => child!,
                    focusNode: FocusNode(),
                    onFocusChange: (focused) {},
                    touchHoverEnterDuration: const Duration(milliseconds: 300),
                    touchHoverExitDuration: Duration.zero,
                    behavior: HitTestBehavior.translucent,
                    onPress: () async{
                        await app.GetProducts();
                      
                    },
                    child: FIcon(FAssets.icons.refreshCw)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  FTextField(
                    onChange: (value) {
                      app.filterProducts(query: value, category: null);
                    },
                    onSubmit: (value) {
                      // Logger().i("Submitted");
                      app.filterProducts(query: value, category: null);

                    },
                    prefixBuilder: (context, value, child) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FIcon(FAssets.icons.search),
                    ),
                    hint: "Search",
                  ),
                  // FButton(
                  //     onPress: () async {
                  //     },
                  //     label: const Text("press")),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 2,
                    child: ListView.builder(
                      itemCount: context.watch<AppProvider>().products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FTappable.animated(
                            onPress: () {
                              Logger().i("Pressed");

                              showFSheet(
                                context: context,
                                side: FLayout.btt,
                                builder: (context) => ItemModal(
                                  product: Products(
                                    app.products[index].name,
                                    app.products[index].url,
                                    app.products[index].category_id,
                                    app.products[index].description,
                                    app.products[index].price,
                                    app.products[index].condition,
                                    app.products[index].seller_name,
                                    app.products[index].seller_id,
                                  ),
                                ),
                              );
                            },
                            semanticLabel: 'Label',
                            semanticSelected: false,
                            excludeSemantics: false,
                            focusNode: FocusNode(),
                            touchHoverEnterDuration:
                                const Duration(milliseconds: 200),
                            touchHoverExitDuration: Duration.zero,
                            behavior: HitTestBehavior.translucent,
                            builder: (context, state, child) => child!,
                            child: FCard(
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$${app.products[index].price}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    app.products[index].condition,
                                  ),
                                ],
                              ),
                              title: Text(
                                context
                                    .read<AppProvider>()
                                    .products[index]
                                    .name,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              image: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(context
                                        .read<AppProvider>()
                                        .products[index]
                                        .url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 100,
                                width: 200,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
