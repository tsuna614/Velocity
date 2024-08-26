import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index * 200.0, // Each container is 200px in height
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll to Index Example'),
      ),
      body: Column(
        children: [
          DropdownButton<int>(
            value: _selectedIndex,
            items: List.generate(50, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text('Item ${index + 1}'),
              );
            }),
            onChanged: (int? value) {
              if (value != null) {
                setState(() {
                  _selectedIndex = value;
                });
                _scrollToIndex(value);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 50,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  color: index % 2 == 0 ? Colors.blue : Colors.green,
                  child: Center(
                    child: Text(
                      'Item ${index + 1}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
