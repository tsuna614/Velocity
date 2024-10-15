import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_app/src/bloc/book/book.events.dart';
import 'package:velocity_app/src/bloc/book/book_bloc.dart';
import 'package:velocity_app/src/services/book_api.dart';
import 'package:velocity_app/src/services/post_api.dart';
import 'package:velocity_app/src/services/travel_api.dart';
import 'package:velocity_app/src/services/user_api.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/bloc/travel/travel_events.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/travel/travel_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/view/auth/log_in.dart';
import 'package:velocity_app/src/view/loading_screen.dart';
import 'package:velocity_app/src/view/main_screen.dart';
import 'dart:io';

final getIt = GetIt.instance;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void setupLocator() {
  // getIt.registerLazySingleton(() => UserBloc());
  // getIt.registerLazySingleton(() => PostBloc());
  // getIt.registerLazySingleton(() => TravelBloc());
  getIt.registerLazySingleton(() => UserApiImpl());
  getIt.registerLazySingleton(() => PostApiImpl());
  getIt.registerLazySingleton(() => TravelApiImpl());
  getIt.registerLazySingleton(() => BookApiImpl());
}

void main() async {
  HttpOverrides.global =
      MyHttpOverrides(); // this is required to import network images from https
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Hive.initFlutter(); // Initialize Hive with Flutter
  await Hive.openBox('credentialsBox'); // Open a box

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(getIt<UserApiImpl>())..add(FetchUser()),
        ),
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(getIt<PostApiImpl>())
            ..add(FetchPosts(postType: PostType.normalPost)),
        ),
        BlocProvider<BookBloc>(
          create: (context) =>
              (BookBloc(getIt<BookApiImpl>())..add(FetchBooks())),
        ),
        BlocProvider<TravelBloc>(
          create: (context) {
            final travelBloc = TravelBloc(getIt<TravelApiImpl>());

            travelBloc.add(LoadData());

            return travelBloc;
          },
        ),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        home: MyHomePage(),
        // home: VideoApp(),
        // home: NestedScrollViewExample(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const LoadingScreen();
          } else if (state is UserLoaded) {
            return const MainScreen();
          } else {
            return const LogInScreen();
          }
        },
      ),
    );
  }
}
