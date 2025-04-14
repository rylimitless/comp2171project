import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:rexcommerce/app_provider.dart';


enum ChatType {
  defaultType,
}


String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class ChatPage extends StatefulWidget {

  // final String msgContext;
  // final String type;
  // final String country;
  // final String topic;
  final String SellerID;

  const ChatPage(this.SellerID , {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }

}

class _ChatPageState extends State<ChatPage> {

  @override
  void initState() {
  print("mgmmg");

    // TODO: implement initState
;
    
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("gone");

    super.dispose();
  }

 final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _chatbbot = const types.User(id:"10-223");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          // print("going back");
          Provider.of<AppProvider>(context,listen: false).messages.clear();
          Navigator.pop(context);
        }, icon: const Icon(Icons.keyboard_double_arrow_left)),
      ),
      body:  Consumer<AppProvider> (
          builder: (context, chatter , child) {


            // if(chatter.q==false){
            // chatter.subscribe("s");
            // chatter.context = widget.msgContext;
            // print(chatter.context);
            // }
  
            return Chat(messages: chatter.messages, onSendPressed: chatter.handleSendPressed, user: _user);
          }

        )
        
    );
  }
}