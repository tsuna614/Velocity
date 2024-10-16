import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/view/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        buildTitle(title: AppLocalizations.of(context)!.myPaymentOptions),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: AppLocalizations.of(context)!.myCards,
              subtitle:
                  AppLocalizations.of(context)!.payYourBookingInOneSingleTap,
              icon: FontAwesomeIcons.creditCard,
              position: ButtonPosition.only,
            ),
          ],
        ),
        buildTitle(title: AppLocalizations.of(context)!.myReceipts),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: AppLocalizations.of(context)!.myReceipts,
              subtitle: AppLocalizations.of(context)!
                  .viewYourBookingReceiptsAndHistory,
              icon: FontAwesomeIcons.clockRotateLeft,
              position: ButtonPosition.only,
            ),
          ],
        ),
        buildTitle(title: AppLocalizations.of(context)!.myRewards),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: AppLocalizations.of(context)!.myMissions,
              subtitle: AppLocalizations.of(context)!.completeMoreMissions,
              icon: FontAwesomeIcons.bookBookmark,
              position: ButtonPosition.top,
            ),
            buildListTileButton(
              title: AppLocalizations.of(context)!.coupons,
              subtitle: AppLocalizations.of(context)!.viewCoupons,
              icon: FontAwesomeIcons.ticket,
              position: ButtonPosition.middle,
            ),
            buildListTileButton(
              title: AppLocalizations.of(context)!.rewards,
              subtitle: AppLocalizations.of(context)!.trackRewards,
              icon: FontAwesomeIcons.coins,
              position: ButtonPosition.bottom,
            ),
          ],
        ),
        buildTitle(title: AppLocalizations.of(context)!.advancedOptions),
        buildButtonsCard(
          buttons: [
            buildListTileButton(
              title: AppLocalizations.of(context)!.helpCenter,
              subtitle: AppLocalizations.of(context)!
                  .findTheBestAnswerToYourQuestions,
              icon: FontAwesomeIcons.circleQuestion,
              position: ButtonPosition.top,
            ),
            buildListTileButton(
              title: AppLocalizations.of(context)!.contactUs,
              subtitle:
                  AppLocalizations.of(context)!.getHelpFromOurCustomerService,
              icon: FontAwesomeIcons.phoneFlip,
              position: ButtonPosition.middle,
            ),
            buildListTileButton(
                title: AppLocalizations.of(context)!.settings,
                subtitle:
                    AppLocalizations.of(context)!.manageYourAccountSettings,
                icon: FontAwesomeIcons.gear,
                position: ButtonPosition.bottom,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const SettingsScreen();
                  }));
                }),
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
    Function()? onTap,
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
        onTap: onTap,
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
