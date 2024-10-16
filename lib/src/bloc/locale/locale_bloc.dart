import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Define Locale Events
abstract class LocaleEvent {}

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
    on<ChangeLocale>((event, emit) {
      emit(LocaleChanged(event.locale));
    });
  }
}
