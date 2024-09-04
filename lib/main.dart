import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/travel/travel_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/view/auth/log_in.dart';
import 'package:velocity_app/src/view/loading_screen.dart';
import 'package:velocity_app/src/view/main_screen.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global =
      MyHttpOverrides(); // this is required to import network images from https
  WidgetsFlutterBinding.ensureInitialized();
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
          create: (context) => UserBloc()
            ..add(FetchUser()), // NOTE: remove ..add(FetchUser()) later
        ),
        BlocProvider<TravelBloc>(
          create: (context) {
            final travelBloc = TravelBloc();

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

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Get Height of Child Widget')),
//         body: MyWidget(),
//       ),
//     );
//   }
// }

// class MyWidget extends StatefulWidget {
//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   final GlobalKey _key = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final RenderBox renderBox =
//           _key.currentContext?.findRenderObject() as RenderBox;
//       final size = renderBox.size;
//       print('Height: ${size.height}');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         key: _key,
//         color: Colors.blue,
//         width: 100,
//         height: 150,
//         child: Center(child: Text('Hello World')),
//       ),
//     );
//   }
// }
