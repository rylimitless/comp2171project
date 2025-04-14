import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:rexcommerce/ads.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:rexcommerce/browse.dart';
import 'package:rexcommerce/chat.dart';
import 'package:rexcommerce/listing.dart';
import 'package:rexcommerce/seller.dart';
import 'package:rexcommerce/widgets/chat_modal.dart';
import 'package:rexcommerce/widgets/nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/widgets/select.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {

  
  int index = 0;
   @override

  void initState() {
    super.initState();
 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      Provider.of<AppProvider>(context,listen: false).subscribe();

      appProvider.GetProducts();
      appProvider.GetCategories();
      appProvider.GetFeaturedProducts();
      appProvider.GetAds();

      Logger().i("MyHomePage initState: Initial data fetch triggered.");
    });
  }

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
      builder: (context, app, child) => FTheme(
            data: FThemes.zinc.light,
            child: FScaffold(
              header: FHeader(
                title: const Text(
                  'RexCommerce',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              content: IndexedStack(
                index: app.homeIndex,
                children: [
                  ListingView(),
                  BrowsePage(),
                  AddProductPage(),
                  ListingPage(),
                  AddsPage(),
                ],
              ),
              footer: FBottomNavigationBar(
                index: app.homeIndex,
                onChange: (index) => setState(() {
                  this.index = index;
                  app.sethomeIndex(index);

                  // switch (index) {
                  //   case 3:
                  //     {
                  //       if (index != 3) {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => ListingPage()));
                  //       }
                  //     }
                  //     break;

                  //   case 4:
                  //     {}
                  //     break;
                  // }
                }),
                children: [
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.house),
                    label: const Text('Home'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.layoutGrid),
                    label: const Text('Browse'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.store),
                    label: const Text('Sell Item'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.libraryBig),
                    label: const Text('My Listing'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.megaphone),
                    label: const Text('Ads'),
                  ),
                ],
              ),
            ),
          ));                                                 
}

class ListingView extends StatelessWidget {
  const ListingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
        header: FHeader(
              title: Text(
                'Home',
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
                    touchHoverEnterDuration: const Duration(milliseconds: 300),
                    touchHoverExitDuration: Duration.zero,
                    behavior: HitTestBehavior.translucent,
                    onPress: () async{
                        await context.read<AppProvider>().GetProducts();
                        await context.read<AppProvider>().GetFeaturedProducts();
                        await context.read<AppProvider>().GetAds();

                      
                    },
                    child: FIcon(FAssets.icons.refreshCw)),
              ],
            ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your campus marketplace',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  // FTextField(
                  //   onSubmit: (value) {
                  //     Logger().i("Submitted");
                  //   },
                  //   prefixBuilder: (context, value, child) => Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: FIcon(FAssets.icons.search),
                  //   ),
                  //   hint: "What are you looking for?",
                  // ),
        
                  //TODO Browse categories
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Promotions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: context.watch<AppProvider>().ads.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FCard(
                            subtitle: Text(context.read<AppProvider>().ads[index].description),
                            title: Text(
                              context.read<AppProvider>().ads[index].name,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            image: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(context
                                      .read<AppProvider>()
                                      .ads[index]
                                      .url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 100,
                              width: 200,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Browse Categories',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: (){
                          showFSheet(
                            mainAxisMaxRatio: 0.5,
                            context: context,
                            side: FLayout.btt,
                            builder: (context) => SelectModal(),
                          );
                        },
                        child: Text("Select",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      )
                     
                    ],
                  ),
                  // FButton(
                  //     onPress: () async {
                  //       await context.read<AppProvider>().GetFeaturedProducts();
                  //     },
                  //     label: const Text("Fetch")),
        

                  
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: context.watch<AppProvider>().categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FCard(
                            title: Text(
                              context.read<AppProvider>().categories[index].name,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            image: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(context
                                      .read<AppProvider>()
                                      .categories[index]
                                      .url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 100,
                              width: 200,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Featured Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(     
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: context.watch<AppProvider>().featured.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FTappable.animated(
                            onPress: () {
                              Logger().i("Pressed");
        
                              showFSheet(
                                mainAxisMaxRatio: 0.9,
                                context: context,
                                side: FLayout.btt,
                                builder: (context) => ItemModal(
                                  product: Products(
                                    context
                                        .read<AppProvider>()
                                        .featured[index]
                                        .name,
                                    context.read<AppProvider>().featured[index].url,
                                    context.read<AppProvider>().featured[index].category_id,
                                    context.read<AppProvider>().featured[index].description,
                                    context.read<AppProvider>().featured[index].price,
                                    context.read<AppProvider>().featured[index].condition,
                                    context.read<AppProvider>().featured[index].seller_name,
                                    context.read<AppProvider>().products[index].seller_id,
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
                                    "\$${context.read<AppProvider>().featured[index].price}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    context.read<AppProvider>().featured[index].condition,
                                  ),
                                ],
                              ),
                              title: Text(
                                context.read<AppProvider>().featured[index].name,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              image: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(context
                                        .read<AppProvider>()
                                        .featured[index]
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
        
                  // FCard(
                  //   title: const Text('Account'),
                  //   subtitle: const Text(
                  //       'Make changes to your account here. Click save when you are done.'),
                  //   child: Column(
                  //     children: [
                  //       const FTextField(
                  //         label: Text('Name'),
                  //         hint: 'John Renalo',
                  //       ),
                  //       const SizedBox(height: 10),
                  //       const FTextField(
                  //         label: Text('Email'),
                  //         hint: 'john@doe.com',
                  //       ),
                  //       const SizedBox(height: 16),
                  //       FButton(
                  //         label: const Text('Save'),
                  //         onPress: () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
