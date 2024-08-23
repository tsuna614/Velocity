import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Widget> names = [];

  void shuffleList() {
    names.shuffle();
  }

  @override
  void initState() {
    for (var i = 0; i < 10; i++) {
      names.add(Container(
        key: UniqueKey(),
        child: NameCheckBox(
          name: 'Name $i',
        ),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(children: names),
          // Expanded(
          //   // child: ListView.builder(
          //   //   shrinkWrap: true,
          //   //   itemCount: names.length,
          //   //   itemBuilder: (context, index) => names[index],
          //   // ),
          //   child: ListView(
          //     children: names.map(
          //       (e) {
          //         return Builder(key: UniqueKey(), builder: (context) => e);
          //       },
          //     ).toList(),
          //   ),
          // ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                shuffleList();
              });
            },
            child: const Text('Shuffle List'),
          ),
        ],
      ),
    );
  }
}

// class MyContainer extends StatefulWidget {
//   const MyContainer({super.key, required this.myWidget});

//   final Widget myWidget;

//   @override
//   State<MyContainer> createState() => _MyContainerState();
// }

// class _MyContainerState extends State<MyContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.myWidget;
//   }
// }

class MyContainer extends StatelessWidget {
  const MyContainer({super.key, required this.myWidget});

  final Widget myWidget;

  @override
  Widget build(BuildContext context) {
    return myWidget;
  }
}

class NameCheckBox extends StatefulWidget {
  const NameCheckBox({
    super.key,
    required this.name,
  });

  final String name;

  @override
  State<NameCheckBox> createState() => _NameCheckBoxState();
}

class _NameCheckBoxState extends State<NameCheckBox> {
  bool isChecked = false;

  @override
  void initState() {
    print("INIT STATE - ${widget.name}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD - ${widget.name}");
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
          Text(widget.name),
        ],
      ),
    );
  }
}
