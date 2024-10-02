import 'package:flutter/material.dart';
import 'package:velocity_app/src/view/booking/my-booking/receipt_page.dart';
import 'package:velocity_app/src/view/booking/my-booking/bookmark_page.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  int _currentPageIndex = 0;

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('Active', 0),
                    buildButton('Past', 1),
                    buildButton('Saved', 2),
                  ],
                ),
                buildActiveButtonOutline(),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: const [
                ReceiptPage(
                  status: ReceiptStatus.active,
                ),
                ReceiptPage(
                  status: ReceiptStatus.past,
                ),
                BookmarkPage(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
            ),
          )
        ],
      ),
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _currentPageIndex == index
              ? TextButton(
                  onPressed: () => _handleTap(index),
                  // style: OutlinedButton.styleFrom(
                  //   side: const BorderSide(
                  //       color: Colors.blue, width: 2), // Border color and width
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30), // Rounded corners
                  //   ),
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20, vertical: 10), // Button padding
                  //   backgroundColor: Colors.blue.withOpacity(0.05),
                  //   splashFactory: NoSplash.splashFactory,
                  // ),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () => _handleTap(index),
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildActiveButtonOutline() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      alignment: _currentPageIndex == 0
          ? Alignment.centerLeft
          : _currentPageIndex == 1
              ? Alignment.center
              : Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue.withOpacity(0.05),
            ),
          ),
        ),
      ),
    );
  }
}
