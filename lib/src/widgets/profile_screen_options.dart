import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/view/settings/settings.dart';

enum ButtonPosition {
  top,
  middle,
  bottom,
  only,
}

class ProfileScreenOptions extends StatefulWidget {
  const ProfileScreenOptions({super.key});

  @override
  State<ProfileScreenOptions> createState() => _ProfileScreenOptionsState();
}

class _ProfileScreenOptionsState extends State<ProfileScreenOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // padding: EdgeInsets.only(top: _profileCardHeight),
      children: [
        buildTitle(title: "My Payment Options"),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: "My Cards",
              subtitle: "Pay your booking in one single tap",
              icon: FontAwesomeIcons.creditCard,
              position: ButtonPosition.only,
            ),
          ],
        ),
        buildTitle(title: "My Receipts"),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: "My Receipts",
              subtitle: "View your booking receipts and history",
              icon: FontAwesomeIcons.clockRotateLeft,
              position: ButtonPosition.only,
            ),
          ],
        ),
        buildTitle(title: "My Rewards"),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: "My Missions",
              subtitle: "Complete more Missions, unlock more rewards",
              icon: FontAwesomeIcons.bookBookmark,
              position: ButtonPosition.top,
            ),
            buildListTileButton(
              title: "Coupons",
              subtitle: "View coupons that you can use now",
              icon: FontAwesomeIcons.ticket,
              position: ButtonPosition.middle,
            ),
            buildListTileButton(
              title: "Rewards",
              subtitle: "Track rewards programs and redeem points",
              icon: FontAwesomeIcons.coins,
              position: ButtonPosition.bottom,
            ),
          ],
        ),
        buildTitle(title: "Advanced Options"),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: "Help Center",
              subtitle: "Find the best answer to your questions",
              icon: FontAwesomeIcons.circleQuestion,
              position: ButtonPosition.top,
            ),
            buildListTileButton(
              title: "Contact Us",
              subtitle: "Get help from our Customer Service",
              icon: FontAwesomeIcons.phoneFlip,
              position: ButtonPosition.middle,
            ),
            buildListTileButton(
              title: "Settings",
              subtitle: "Manage your account settings",
              icon: FontAwesomeIcons.gear,
              position: ButtonPosition.bottom,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 40.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonsCard({required List<Widget> buttons}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Column(
          children: buttons.map(
            (button) {
              return Column(
                children: [
                  if (buttons.indexOf(button) != 0)
                    const Divider(
                      height: 0,
                    ),
                  button,
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget buildListTileButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required ButtonPosition position,
  }) {
    // this long as code is basically just to make the inkwell's splash's corners rounded based on the position
    final BorderRadius borderRadius = BorderRadius.only(
      topLeft: position == ButtonPosition.top || position == ButtonPosition.only
          ? const Radius.circular(10)
          : Radius.zero,
      topRight:
          position == ButtonPosition.top || position == ButtonPosition.only
              ? const Radius.circular(10)
              : Radius.zero,
      bottomLeft:
          position == ButtonPosition.bottom || position == ButtonPosition.only
              ? const Radius.circular(10)
              : Radius.zero,
      bottomRight:
          position == ButtonPosition.bottom || position == ButtonPosition.only
              ? const Radius.circular(10)
              : Radius.zero,
    );

    return Material(
      borderRadius: borderRadius,
      clipBehavior:
          Clip.hardEdge, // apply this for the inkwell to have rounder corners
      child: InkWell(
        onTap: () {
          if (title == "Settings") {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const SettingsScreen();
            }));
          }
        },
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          leading: Icon(icon),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
      ),
    );
  }
}
