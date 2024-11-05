import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/l10n/app_localizations.dart';

class CreatePostOptions extends StatelessWidget {
  const CreatePostOptions({super.key, required this.onFunctionCallback});

  final void Function(int) onFunctionCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 0,
        ),
        buildInkWellButton(
          icon: FontAwesomeIcons.image,
          color: Colors.blue,
          text: AppLocalizations.of(context)!.pickImageFromGallery,
          onTap: () {
            onFunctionCallback(0);
          },
        ),
        const Divider(
          height: 0,
        ),
        buildInkWellButton(
          icon: FontAwesomeIcons.video,
          color: Colors.purple,
          text: AppLocalizations.of(context)!.pickVideoFromGallery,
          onTap: () {
            onFunctionCallback(1);
          },
        ),
        const Divider(
          height: 0,
        ),
        buildInkWellButton(
          icon: FontAwesomeIcons.camera,
          color: Colors.red,
          text: AppLocalizations.of(context)!.takePhoto,
          onTap: () {
            onFunctionCallback(2);
          },
        ),
        const Divider(
          height: 0,
        ),
        buildInkWellButton(
          icon: FontAwesomeIcons.locationDot,
          color: Colors.green,
          text: AppLocalizations.of(context)!.addLocation,
          onTap: () {
            onFunctionCallback(3);
          },
        ),
        const Divider(
          height: 0,
        ),
        buildInkWellButton(
          icon: FontAwesomeIcons.userTag,
          color: Colors.orange,
          text: AppLocalizations.of(context)!.addPeople,
          onTap: () {
            onFunctionCallback(4);
          },
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }

  Widget buildInkWellButton({
    required IconData icon,
    required Color color,
    required String text,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}
