import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/view/booking/payment-flow/detail_filling_screen.dart';
import 'package:velocity_app/src/view/booking/payment-flow/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen(
      {super.key, required this.travelData, required this.amount});

  final Travel travelData;
  final int amount;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  late final MyUser user;

  void pushToPaymentScreen() {
    setState(() {
      _currentPageIndex = 1;
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void initState() {
    user = (BlocProvider.of<UserBloc>(context).state as UserLoaded).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            setState(() {
              _currentPageIndex = 0;
              if (_pageController.page == 0) {
                Navigator.pop(context);
              } else {
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(_currentPageIndex == 0 ? "Booking" : "Paying & Finalizing"),
        bottom: buildAppBarBottom(),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          DetailFillingScreen(
            travelData: widget.travelData,
            userData: user,
            amount: widget.amount,
            navigateToPayment: pushToPaymentScreen,
          ),
          PaymentScreen(
            travelData: widget.travelData,
            amount: widget.amount,
          ),
        ],
      ),
    );
  }

  PreferredSize buildAppBarBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.blue, // AppBar bottom background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // This represents the step progression indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: _currentPageIndex == 0 ? 50 : 0,
                ),
              ),
              buildPageTag(
                  index: 0,
                  title: "Fill in details",
                  isActive: _currentPageIndex == 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: 20,
                  height: 1,
                  color: Colors.white,
                ),
              ),
              buildPageTag(
                  index: 1, title: "Payment", isActive: _currentPageIndex == 1),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: _currentPageIndex == 1 ? 50 : 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageTag(
      {required int index, required String title, required bool isActive}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(100),
          ),
          child: SizedBox(
            height: isActive ? 20 : 18,
            width: isActive ? 20 : 18,
            child: Center(
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            fontSize: isActive ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
