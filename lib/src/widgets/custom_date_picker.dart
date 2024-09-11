import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker(
      {super.key, required this.onDateSelected, required this.selectedDate});

  final void Function(DateTime date) onDateSelected;
  final DateTime selectedDate;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final DateTime _initialDate = DateTime.now();

  void _handleCalendarButtonPress() async {
    showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: _initialDate,
      lastDate: _initialDate.add(const Duration(days: 365)),
    ).then((DateTime? value) {
      if (value != null) {
        widget.onDateSelected(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose Your Date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                buildCalendarButton(),
                Expanded(
                  child: buildHorizontalDateButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendarButton() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: double.infinity,
        width: 40,
        child: ElevatedButton(
          onPressed: _handleCalendarButtonPress,
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            overlayColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
          ),
          child: const Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildHorizontalDateButton() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 15,
      itemBuilder: (context, index) {
        DateTime currentIndexDate = _initialDate.add(Duration(days: index));
        bool isSelected = widget.selectedDate.day == currentIndexDate.day;

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {
                widget.onDateSelected(currentIndexDate);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                foregroundColor: isSelected ? Colors.blue : Colors.white,
                overlayColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      DateFormat.E().format(currentIndexDate),
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${currentIndexDate.day} ${DateFormat.MMM().format(currentIndexDate)}',
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
