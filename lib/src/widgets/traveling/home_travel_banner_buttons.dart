import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/l10n/app_localizations.dart';

class HomeTravelBannerButtons extends StatefulWidget {
  const HomeTravelBannerButtons({super.key, required this.onPressed});

  final void Function(int index) onPressed;

  @override
  State<HomeTravelBannerButtons> createState() =>
      _HomeTravelBannerButtonsState();
}

class _HomeTravelBannerButtonsState extends State<HomeTravelBannerButtons> {
  final List<IconData> _bannerIcons = [
    FontAwesomeIcons.signsPost,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.car,
  ];
  final List<Color> _bannerColors = [
    Colors.orange,
    Colors.green,
    Colors.lightBlue,
    const Color.fromARGB(255, 0, 110, 201),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> bannerDescriptions = [
      AppLocalizations.of(context)!.bookATour,
      AppLocalizations.of(context)!.bookAHotel,
      AppLocalizations.of(context)!.bookAFlight,
      AppLocalizations.of(context)!.bookACar,
    ];

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            bannerDescriptions.length,
            (index) => Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onPressed(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: _bannerColors[index],
                      ),
                      child: Icon(
                        _bannerIcons[index],
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        bannerDescriptions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
