import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';

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
          title: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _logOut();
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(title: "ACCOUNT & SECURITY"),
        buildListTileButton(
          title: "Account Information",
          icon: FontAwesomeIcons.user,
        ),
        buildListTileButton(
          title: "Password & Security",
          icon: FontAwesomeIcons.shieldHalved,
        ),
        buildListTileButton(
          title: "Profile Privacy",
          icon: FontAwesomeIcons.lock,
        ),
        buildTitle(title: "PREFERENCES"),
        buildListTileButton(
          title: "Language",
        ),
        const SizedBox(height: 20),
        buildListTileButton(
          title: "Terms & Conditions",
        ),
        buildListTileButton(
          title: "Privacy Policy",
        ),
        buildListTileButton(
          title: "About Us",
        ),
        const SizedBox(height: 20),
        buildListTileButton(
          title: "Log Out",
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
