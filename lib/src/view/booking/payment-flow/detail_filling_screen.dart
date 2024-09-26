import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/animated_button_1.dart';

class DetailFillingScreen extends StatefulWidget {
  const DetailFillingScreen(
      {super.key,
      required this.travelData,
      required this.userData,
      required this.amount,
      required this.navigateToPayment});

  final Travel travelData;
  final MyUser userData;
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
          buildVisitorDetails(),
          buildPriceDetails(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: AnimatedButton1(
              buttonText: "Continue to payment",
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
                const Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                          "Please check your booking details before proceeding to payment"),
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
                            "Amount: ${widget.amount}",
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
                        "Logged in as ${widget.userData.firstName} ${widget.userData.lastName}",
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

  Widget buildVisitorDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              "Guest Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailTextRow(
                      tag: "Name",
                      content:
                          "Mr. ${widget.userData.firstName} ${widget.userData.lastName}"),
                  const Divider(),
                  buildDetailTextRow(
                      tag: "Phone Number",
                      content: "+${widget.userData.phone}"),
                  const Divider(),
                  buildDetailTextRow(
                      tag: "Email", content: widget.userData.email),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPriceDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              "Price Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailTextRow(
                      tag: "Amount",
                      content:
                          "${widget.amount} x \$${widget.travelData.price}"),
                  buildDetailTextRow(
                      tag: "Tax",
                      content: "10% x \$${widget.travelData.price}"),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  buildDetailTextRow(
                      tag: "Total",
                      content:
                          "\$${widget.amount * widget.travelData.price * 1.1}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailTextRow({required String tag, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            tag,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const Spacer(),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
