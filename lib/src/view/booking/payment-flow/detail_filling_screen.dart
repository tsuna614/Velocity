import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/animated_button_1.dart';
import 'package:velocity_app/src/widgets/booking/receipt_details.dart';
import 'package:velocity_app/l10n/app_localizations.dart';

class DetailFillingScreen extends StatefulWidget {
  const DetailFillingScreen(
      {super.key,
      required this.travelData,
      required this.userData,
      required this.amount,
      required this.navigateToPayment});

  final TravelModel travelData;
  final UserModel userData;
  final int amount;
  final void Function() navigateToPayment;

  @override
  State<DetailFillingScreen> createState() => _DetailFillingScreenState();
}

class _DetailFillingScreenState extends State<DetailFillingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBookingDetailsCard(),
          buildUserAccountDetails(),
          ReceiptDetails(
            travelData: widget.travelData,
            userData: widget.userData,
            amount: widget.amount,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: AnimatedButton1(
              buttonText: AppLocalizations.of(context)!.continueToPayment,
              height: 50,
              voidCallback: () {
                widget.navigateToPayment();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                          AppLocalizations.of(context)!.pleaseCheckYourBooking),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.travelData.imageUrl[0],
                      height: 70,
                      width: 70,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.travelData.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.amount}: ${widget.amount}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserAccountDetails() {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.userData.profileImageUrl.isNotEmpty
                        ? widget.userData.profileImageUrl
                        : "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg",
                    // scale: 20,
                  ),
                  radius: 20,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.loggedInAs} ${widget.userData.firstName} ${widget.userData.lastName}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.userData.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
