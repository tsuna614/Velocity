import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeTravelBannerButtons extends StatefulWidget {
  const HomeTravelBannerButtons({super.key});

  @override
  State<HomeTravelBannerButtons> createState() =>
      _HomeTravelBannerButtonsState();
}

class _HomeTravelBannerButtonsState extends State<HomeTravelBannerButtons> {
  List<String> _bannerDescriptions = [
    'Book a tour',
    'Book a hotel',
    'Book a flight',
    'Book a car',
  ];
  List<IconData> _bannerIcons = [
    FontAwesomeIcons.signsPost,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.car,
  ];
  List<Color> _bannerColors = [
    Colors.orange,
    Colors.green,
    Colors.lightBlue,
    const Color.fromARGB(255, 0, 110, 201),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        _bannerDescriptions.length,
        (index) => Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Icon(_bannerIcons[index]),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      // border: Border.all(width: 2, color: Colors.blue),
                      color: _bannerColors[index]),
                  child: Icon(
                    _bannerIcons[index],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  _bannerDescriptions[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
