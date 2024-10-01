import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/travel_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key, required this.travelData, required this.amount});

  final Travel travelData;
  final int amount;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/2/2f/Rickrolling_QR_code.png",
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Scan the QR code to pay",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Complete Payment"),
          ),
        ),
      ],
    );
  }
}
