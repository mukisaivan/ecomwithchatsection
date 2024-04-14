import 'package:ecomm/chatservice/screens/chat_screen.dart';
import 'package:ecomm/chatservice/screens/mobile_chat_screen.dart';
import 'package:ecomm/pages/homepage.dart';
import 'package:flutter/material.dart';

Route<dynamic> genarateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case ChatScreen.routeName:
      var arguments = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) => ChatScreen(
                receiver: arguments,
              ));

    case MobileChatScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );

    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("This route does not exist"),
          ),
        ),
      );
  }
}
