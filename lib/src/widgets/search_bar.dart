import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final String hintText;
  final bool enableBorder;
  const MySearchBar(
      {super.key, required this.hintText, this.enableBorder = false});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  bool isSearchBarExtended = false;
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 40,
            width: isSearchBarExtended
                ? MediaQuery.of(context).size.width * 1
                : 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: widget.enableBorder
                    ? Colors.black.withOpacity(0.5)
                    : Colors.transparent,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: widget.enableBorder
                    ? Colors.black.withOpacity(0.5)
                    : Colors.transparent,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearchBarExtended = !isSearchBarExtended;
                });
              },
            ),
          ),
          Positioned(
            top: 7,
            left: 50,
            right: 20,
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _searchBarController,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                onChanged: (value) {
                  // _notifier.value = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
