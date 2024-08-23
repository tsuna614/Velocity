import 'package:flutter/material.dart';

class UserBookingScreen extends StatefulWidget {
  const UserBookingScreen({super.key});

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  int _currentPageIndex = 0;

  List<Widget> _pages = const [
    PendingPage(),
    ActivePage(),
    PastPage(),
  ];

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('Pending', 0),
              buildButton('Active', 1),
              buildButton('Past', 2),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
        )
      ],
    );
  }

  void _handleTap(int index) {
    setState(() {
      _currentPageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Widget buildButton(String text, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // duration: const Duration(milliseconds: 500),
        // transitionBuilder: (Widget child, Animation<double> animation) {
        //   return FadeTransition(opacity: animation, child: child);
        // },
        child: _currentPageIndex == index
            ? OutlinedButton(
                onPressed: () => _handleTap(index),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Colors.blue, width: 2), // Border color and width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Button padding
                  backgroundColor: Colors.blue.withOpacity(0.05),
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              )
            : TextButton(
                onPressed: () => _handleTap(index),
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
      ),
    );
  }
}

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pending Page"),
    );
  }
}

class ActivePage extends StatelessWidget {
  const ActivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Active Page"),
    );
  }
}

class PastPage extends StatelessWidget {
  const PastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Past Page"),
    );
  }
}
