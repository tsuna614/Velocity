import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/view/settings/language_selection_screen.dart';
import 'package:velocity_app/l10n/app_localizations.dart';

class SettingsScreenOptions extends StatefulWidget {
  const SettingsScreenOptions({super.key});

  @override
  State<SettingsScreenOptions> createState() => _SettingsScreenOptionsState();
}

class _SettingsScreenOptionsState extends State<SettingsScreenOptions> {
  Future<void> _logOut() async {
    BlocProvider.of<UserBloc>(context).add(SignOut());
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.areYouSureYouWantToLogOut),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text(AppLocalizations.of(context)!.logOut),
            ),
          ],
        );
      },
    );
  }

  void _pushToLanguageScreen() {
    // push to the language screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LanguageSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(title: AppLocalizations.of(context)!.accountAndSecurity),
        buildListTileButton(
          title: AppLocalizations.of(context)!.accountInformation,
          icon: FontAwesomeIcons.user,
        ),
        buildListTileButton(
          title: AppLocalizations.of(context)!.passwordAndSecurity,
          icon: FontAwesomeIcons.shieldHalved,
        ),
        buildListTileButton(
          title: AppLocalizations.of(context)!.profilePrivacy,
          icon: FontAwesomeIcons.lock,
        ),
        buildTitle(title: AppLocalizations.of(context)!.preferences),
        buildListTileButton(
            icon: FontAwesomeIcons.globe,
            title: AppLocalizations.of(context)!.language,
            onTap: _pushToLanguageScreen),
        const SizedBox(height: 20),
        buildListTileButton(
          title: AppLocalizations.of(context)!.termsAndConditions,
        ),
        buildListTileButton(
          title: AppLocalizations.of(context)!.privacyPolicy,
        ),
        buildListTileButton(
          title: AppLocalizations.of(context)!.aboutUs,
        ),
        const SizedBox(height: 20),
        buildListTileButton(
          title: AppLocalizations.of(context)!.logOut,
          onTap: _showAlert,
          icon: FontAwesomeIcons.arrowRightFromBracket,
        ),
      ],
    );
  }

  Widget buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 40.0, bottom: 10.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTileButton({
    required String title,
    Function()? onTap,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Material(
        clipBehavior:
            Clip.hardEdge, // apply this for the inkwell to have rounder corners
        child: InkWell(
          onTap: () {
            onTap?.call();
          },
          child: ListTile(
            title: Text(title),
            leading: icon == null ? null : Icon(icon),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
