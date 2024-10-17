import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/locale/locale_bloc.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<String> titles = [
    "English",
    "Española (Spanish)",
    "Française (French)",
    "日本語 (Japanese)",
    "Tiếng Việt (Vietnamese)",
  ];

  final List<String> locales = [
    "en",
    "es",
    "fr",
    "ja",
    "vi",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Language")),
      body: Column(
        children: [
          for (int i = 0; i < titles.length; i++)
            buildTile(title: titles[i], locale: locales[i]),
        ],
      ),
    );
  }

  Widget buildTile({required String title, required String locale}) {
    return ListTile(
      tileColor:
          BlocProvider.of<LocaleBloc>(context).state.locale == Locale(locale)
              ? Colors.grey.shade300
              : null,
      title: Text(title),
      onTap: () {
        BlocProvider.of<LocaleBloc>(context).add(ChangeLocale(Locale(locale)));
        Navigator.pop(context); // Close the settings screen
      },
    );
  }
}
