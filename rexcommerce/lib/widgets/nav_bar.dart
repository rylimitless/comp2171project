import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:rexcommerce/listing.dart';



class BottomNavBar extends StatefulWidget {
  int index;

  BottomNavBar({required this.index});

  @override
  _MyBottomNavBar createState() => _MyBottomNavBar();

}
class _MyBottomNavBar extends State<BottomNavBar> {


  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBar(
        index: widget.index,
        onChange: (index) => setState(() { 
          
          widget.index = index;

          switch (index){
            case 3 : {
                if(index!=3) Navigator.push(context, MaterialPageRoute(builder: (context)=>ListingPage()));
            } break;

            case 4 :{
              
            }break;
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
      );
  }
  
}

