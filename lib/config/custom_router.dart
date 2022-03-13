import 'package:code/screens/messaging_screen/search/search_screen.dart';
import 'package:code/screens/nav_screen/create_room_screen.dart';
import 'package:code/screens/room_screen/room_description.dart';
import 'package:code/screens/room_screen/room_screen.dart';
import 'package:code/screens/screens.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routename:
        return SplashScreen.route();
      case NavScreen.routename:
        return NavScreen.route();
      case AuthenticationScreen.routename:
        return AuthenticationScreen.route();
      case PinCodeVerificationScreen.routename:
        return PinCodeVerificationScreen.route(
          args: settings.arguments as PinCodeVerificationScreenArgs,
        );
      case MessagingScreen.routeName:
        return MessagingScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route(
          args: settings.arguments as ChatScreenArgs,
        );
      case SearchScreen.routeName:
        return SearchScreen.route();
      case CreateRoomScreen.routeName:
        return CreateRoomScreen.route();
      case RoomScreen.routeName:
        return RoomScreen.route(args: settings.arguments as RoomArgs);
      case RoomDescription.routeName:
        return RoomDescription.route(args: settings.arguments as RoomDesArgs);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
