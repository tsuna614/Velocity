import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocity_app/src/bloc/tour_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TourBloc()..add(LoadTours()),
      child: const Scaffold(
        body: Center(
          child: TourPage(),
        ),
      ),
    );
  }
}

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  void handlePress(BuildContext context) {
    print(BlocProvider.of<TourBloc>(context).state.tours[0].name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourBloc, TourState>(builder: (context, state) {
      return ElevatedButton(
        onPressed: () => handlePress(context),
        child: Text(AppLocalizations.of(context)!.letsGetStarted),
      );
    });
  }
}
