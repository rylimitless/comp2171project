import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:rexcommerce/app_provider.dart';
import 'package:rexcommerce/listing.dart';
import 'package:rexcommerce/seller.dart';
import 'package:rexcommerce/widgets/nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

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
                index: index,
                children: [
                  ListingView(),
                  Text("Browse"),
                  AddProductPage(),
                  ListingPage(),
                ],
              ),
              footer: FBottomNavigationBar(
                index: index,
                onChange: (index) => setState(() {
                  this.index = index;

                  switch (index) {
                    case 3:
                      {
                        if (index != 3)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListingPage()));
                      }
                      break;

                    case 4:
                      {}
                      break;
                  }
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
                    icon: FIcon(FAssets.icons.messageCircle),
                    label: const Text('Messages'),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const Text(
                'Your campus marketplace',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              FTextField(
                onSubmit: (value) {
                  Logger().i("Submitted");
                },
                prefixBuilder: (context, value, child) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FIcon(FAssets.icons.search),
                ),
                hint: "What are you looking for?",
              ),

              //TODO Browse categories
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Browse Categories'),
                  const Text(
                    'Show All',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline),
                  )
                ],
              ),
              FButton(
                  onPress: () async {
                    await context.read<AppProvider>().GetCategories();
                  },
                  label: const Text("Fetch")),

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
    );
  }
}
