import 'package:flutter/material.dart';

class SortButtonHorizontalList extends StatefulWidget {
  const SortButtonHorizontalList({super.key, required this.sortOptions});

  final List<String> sortOptions;

  @override
  State<SortButtonHorizontalList> createState() =>
      _SortButtonHorizontalListState();
}

class _SortButtonHorizontalListState extends State<SortButtonHorizontalList> {
  // final List<String> selectedItems = [];
  String selectedItems = '';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.sortOptions.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedItems.contains(widget.sortOptions[index]);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                // if (isSelected) {
                //   selectedItems.remove(widget.sortOptions[index]);
                // } else {
                //   selectedItems.add(widget.sortOptions[index]);
                // }
                selectedItems = widget.sortOptions[index];
              });
            },
            style: ButtonStyle(
              // border
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (isSelected) {
                    return Colors.blue;
                  }
                  return Colors.white;
                },
              ),
            ),
            child: Text(
              widget.sortOptions[index],
              style: TextStyle(color: isSelected ? Colors.white : Colors.blue),
            ),
          ),
        );
      },
    );
  }
}
