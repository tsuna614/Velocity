import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/book/book.events.dart';
import 'package:velocity_app/src/bloc/book/book_bloc.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  final Book bookData;
  const PaymentScreen({super.key, required this.bookData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> _processPayment(BuildContext context) async {
    BlocProvider.of<BookBloc>(context).add(AddBook(widget.bookData));
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking successful!"),
      ),
    );
  }

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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.scanTheQRCodeToPay,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: ElevatedButton(
            onPressed: () {
              _processPayment(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.completePayment),
          ),
        ),
      ],
    );
  }
}
