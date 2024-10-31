import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/book_model.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/view/booking/my-booking/receipt_tab.dart';
import 'package:velocity_app/src/widgets/booking/receipt_details.dart';

String formattedDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year} ${date.hour < 10 ? '0${date.hour}' : date.hour}:${date.minute < 10 ? '0${date.minute}' : date.minute}";
}

class TravelBookingReceipt extends StatelessWidget {
  final TravelModel travelData;
  final BookModel bookData;
  final ReceiptStatus status;
  const TravelBookingReceipt({
    super.key,
    required this.travelData,
    required this.bookData,
    required this.status,
  });

  void _navigateToReceipt(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Receipt Details"),
            ),
            body: ReceiptDetails(
              travelData: travelData,
              userData:
                  (BlocProvider.of<UserBloc>(context).state as UserLoaded).user,
              amount: bookData.amount,
              bookData: bookData,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {
                _navigateToReceipt(context);
              },
              child: buildReceiptTile(),
            ),
          ),
        ),
        buildBottomTags(),
      ],
    );
  }

  Widget buildReceiptTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: SizedBox(
          child: Image.network(
            travelData.imageUrl[0],
            width: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/image-error.png",
                width: 80,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        title: Text(travelData.title),
        subtitle: Text(formattedDate(bookData.dateOfBooking)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Total"),
            Text("\$${travelData.price * bookData.amount}"),
          ],
        ),
      ),
    );
  }

  Widget buildBottomTags() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              travelData.runtimeType.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color:
                  status == ReceiptStatus.active ? Colors.green : Colors.grey,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(
              status == ReceiptStatus.active ? "Active" : "Past",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class TravelBookingReceiptSkeleton extends StatefulWidget {
  const TravelBookingReceiptSkeleton({super.key});

  @override
  State<TravelBookingReceiptSkeleton> createState() =>
      _TravelBookingReceiptSkeletonState();
}

class _TravelBookingReceiptSkeletonState
    extends State<TravelBookingReceiptSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade300,
            ),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 150,
              height: 20,
              color: Colors.grey.shade300,
            ),
          ),
          subtitle: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 100,
              height: 20,
              color: Colors.grey.shade300,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 50,
                  height: 20,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
