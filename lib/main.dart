import 'package:code/blocs/blocs.dart';
import 'package:code/config/custom_router.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/screens.dart';
import 'package:code/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/room_screen/cubits/liked_posts/liked_posts_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (_) => StorageRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (_) => PostRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<LikedPostsCubit>(
            create: (context) => LikedPostsCubit(
              postRepository: context.read<PostRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Instagram',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            primaryColor: appBarBackgroundColor,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.lightGreen[50]),
            appBarTheme: const AppBarTheme(
                color: appBarBackgroundColor,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.black)),
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routename,
        ),
      ),
    );
  }
}
