import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/model/user_model.dart';

String formattedDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year} ${date.hour < 10 ? '0${date.hour}' : date.hour}:${date.minute < 10 ? '0${date.minute}' : date.minute}";
}

class ReceiptDetails extends StatefulWidget {
  final Travel travelData;
  final MyUser userData;
  final int amount;
  final Book? bookData;
  const ReceiptDetails({
    super.key,
    required this.travelData,
    required this.userData,
    required this.amount,
    this.bookData,
  });

  @override
  State<ReceiptDetails> createState() => _ReceiptDetailsState();
}

class _ReceiptDetailsState extends State<ReceiptDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildVisitorDetails(),
        if (widget.bookData != null)
          buildBookingDates(bookData: widget.bookData!),
        buildPriceDetails(),
      ],
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

  Widget buildBookingDates({required Book bookData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              "Booking Dates",
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
                      tag: "Booking Date",
                      content: formattedDate(bookData.dateOfBooking)),
                  const Divider(),
                  buildDetailTextRow(
                      tag: "Date of Travel",
                      content: formattedDate(bookData.dateOfTravel)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}