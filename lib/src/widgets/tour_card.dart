import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:velocity_app/src/model/tour_model.dart';

class TourCard extends StatelessWidget {
  const TourCard({super.key, required this.travelData});

  final List<Travel> travelData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemCount: travelData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              elevation: 2,
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    FadeInImage(
                      height: 200,
                      width: 200,
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(travelData[index].imageUrl[0]),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Container(
                        width: 200,
                        child: buildTourDetails(context, travelData, index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTourDetails(
      BuildContext context, List<Travel> travelData, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            travelData[index].name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            travelData[index] is Tour
                ? (travelData[index] as Tour).duration
                : "null",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 104, 104, 104),
            ),
          ),
          Text(
            "\$${travelData[index].price}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 5; i++)
                  travelData[index].rating - i <= 0
                      ? const Icon(
                          Icons.star_border,
                          color: Colors.orange,
                        )
                      : travelData[index].rating - i < 1
                          ? const Icon(
                              Icons.star_half,
                              color: Colors.orange,
                            )
                          : const Icon(
                              Icons.star,
                              color: Colors.orange,
                            )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
