import 'package:flutter/material.dart';
import 'package:velocity_app/l10n/app_localizations.dart';

class AmountPicker extends StatefulWidget {
  const AmountPicker({
    super.key,
    required this.money,
    required this.description,
    required this.onAmountSelected,
    required this.amount,
  });

  final double money;
  final String description;
  final Function(int) onAmountSelected;
  final int amount;

  @override
  State<AmountPicker> createState() => _AmountPickerState();
}

class _AmountPickerState extends State<AmountPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.chooseYourAmount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${widget.money}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 60, 0),
                      ),
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              buildCounter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCounter() {
    return Row(
      children: [
        buildCounterButtons("remove"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Text(
              widget.amount.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        buildCounterButtons("add"),
      ],
    );
  }

  Widget buildCounterButtons(String buttonType) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.amount <= 0 && buttonType == "remove"
            ? Colors.grey[300]
            : Colors.grey[200],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (buttonType == "add") {
              widget.onAmountSelected(widget.amount + 1);
            } else {
              if (widget.amount > 0) {
                widget.onAmountSelected(widget.amount - 1);
              }
            }
          },
          child: Icon(
            buttonType == "add" ? Icons.add : Icons.remove,
            color: widget.amount <= 0 && buttonType == "remove"
                ? Colors.grey
                : Colors.blue,
          ),
        ),
      ),
    );
  }
}
