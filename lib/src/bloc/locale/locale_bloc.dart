import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:velocity_app/src/hive/hive_service.dart';

// Define Locale Events
abstract class LocaleEvent {}

class FetchLocale extends LocaleEvent {}

class ChangeLocale extends LocaleEvent {
  final Locale locale;
  ChangeLocale(this.locale);
}

// Define Locale State
abstract class LocaleState {
  final Locale locale;
  const LocaleState(this.locale);
}

class LocaleInitial extends LocaleState {
  const LocaleInitial(super.locale);
}

class LocaleChanged extends LocaleState {
  const LocaleChanged(super.locale);
}

// LocaleBloc to handle Locale changes
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleInitial(Locale('en'))) {
    on<FetchLocale>((event, emit) async {
      final locale = Locale(await HiveService.getLocale());
      emit(LocaleInitial(locale));
    });

    on<ChangeLocale>((event, emit) {
      HiveService.storeLocale(event.locale.languageCode);
      emit(LocaleChanged(event.locale));
    });
  }
}
