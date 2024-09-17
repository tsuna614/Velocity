// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/widgets.dart';

// // // // class TestScreen extends StatefulWidget {
// // // //   @override
// // // //   _TestScreenState createState() => _TestScreenState();
// // // // }

// // // // class _TestScreenState extends State<TestScreen> {
// // // //   final ScrollController _scrollController = ScrollController();
// // // //   int _selectedIndex = 0;

// // // //   void _scrollToIndex(int index) {
// // // //     _scrollController.animateTo(
// // // //       index * 200.0, // Each container is 200px in height
// // // //       duration: const Duration(seconds: 1),
// // // //       curve: Curves.easeInOut,
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text('Scroll to Index Example'),
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           DropdownButton<int>(
// // // //             value: _selectedIndex,
// // // //             items: List.generate(50, (index) {
// // // //               return DropdownMenuItem(
// // // //                 value: index,
// // // //                 child: Text('Item ${index + 1}'),
// // // //               );
// // // //             }),
// // // //             onChanged: (int? value) {
// // // //               if (value != null) {
// // // //                 setState(() {
// // // //                   _selectedIndex = value;
// // // //                 });
// // // //                 _scrollToIndex(value);
// // // //               }
// // // //             },
// // // //           ),
// // // //           Expanded(
// // // //             child: ListView.builder(
// // // //               controller: _scrollController,
// // // //               itemCount: 50,
// // // //               itemBuilder: (context, index) {
// // // //                 return Container(
// // // //                   height: 200,
// // // //                   color: index % 2 == 0 ? Colors.blue : Colors.green,
// // // //                   child: Center(
// // // //                     child: Text(
// // // //                       'Item ${index + 1}',
// // // //                       style: const TextStyle(fontSize: 24, color: Colors.white),
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/scheduler.dart';

// // // class TestScreen extends StatefulWidget {
// // //   const TestScreen({Key? key, this.title}) : super(key: key);
// // //   final String? title;

// // //   @override
// // //   State<TestScreen> createState() => _TestScreenState();
// // // }

// // // class _TestScreenState extends State<TestScreen> {
// // //   final controller = ScrollController();
// // //   OverlayEntry? sticky;
// // //   GlobalKey stickyKey = GlobalKey();

// // //   @override
// // //   void initState() {
// // //     sticky?.remove();

// // //     sticky = OverlayEntry(
// // //       builder: (context) => stickyBuilder(context),
// // //     );

// // //     SchedulerBinding.instance.addPostFrameCallback((_) {
// // //       if (sticky != null) {
// // //         Overlay.of(context).insert(sticky!);
// // //       }
// // //     });

// // //     super.initState();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     sticky?.remove();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       body: ListView.builder(
// // //         controller: controller,
// // //         itemBuilder: (context, index) {
// // //           if (index == 6) {
// // //             return Container(
// // //               key: stickyKey,
// // //               height: 100.0,
// // //               color: Colors.green,
// // //               child: const Text("I'm fat"),
// // //             );
// // //           }
// // //           return ListTile(
// // //             title: Text(
// // //               'Hello $index',
// // //               style: const TextStyle(color: Colors.white),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   Widget stickyBuilder(BuildContext context) {
// // //     return AnimatedBuilder(
// // //       animation: controller,
// // //       builder: (context, child) {
// // //         final keyContext = stickyKey.currentContext;
// // //         if (keyContext != null) {
// // //           // widget is visible
// // //           final box = keyContext.findRenderObject() as RenderBox;
// // //           final pos = box.localToGlobal(Offset.zero);
// // //           return Positioned(
// // //             top: pos.dy + box.size.height,
// // //             left: 50.0,
// // //             right: 50.0,
// // //             height: box.size.height,
// // //             child: Material(
// // //               child: Container(
// // //                 alignment: Alignment.center,
// // //                 color: Colors.purple,
// // //                 child: const Text("^ Nah I think you're okay"),
// // //               ),
// // //             ),
// // //           );
// // //         }
// // //         return Container();
// // //       },
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';

// // class TestScreen extends StatefulWidget {
// //   const TestScreen({super.key});

// //   @override
// //   State<TestScreen> createState() => _TestScreenState();
// // }

// // class _TestScreenState extends State<TestScreen> {
// //   final ScrollController _scrollController = ScrollController();
// //   bool _isPanelVisible = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController.addListener(_scrollListener);
// //   }

// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   void _scrollListener() {
// //     if (_scrollController.position.userScrollDirection ==
// //         ScrollDirection.reverse) {
// //       // User is scrolling down, hide the panel
// //       if (_isPanelVisible) {
// //         setState(() {
// //           _isPanelVisible = false;
// //         });
// //       }
// //     } else if (_scrollController.position.userScrollDirection ==
// //         ScrollDirection.forward) {
// //       // User is scrolling up, show the panel
// //       if (!_isPanelVisible) {
// //         setState(() {
// //           _isPanelVisible = true;
// //         });
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Scroll Panel Example")),
// //       body: Stack(
// //         children: [
// //           SingleChildScrollView(
// //             controller: _scrollController,
// //             child: Column(
// //               children: List.generate(30, (index) {
// //                 return Container(
// //                   height: 100,
// //                   margin: EdgeInsets.all(8),
// //                   color: Colors.blue[100 * (index % 9)],
// //                   child: Center(child: Text("Item $index")),
// //                 );
// //               }),
// //             ),
// //           ),
// //           // Panel that appears/disappears at the bottom
// //           AnimatedPositioned(
// //             duration: Duration(milliseconds: 300),
// //             curve: Curves.easeInOut,
// //             left: 0,
// //             right: 0,
// //             bottom: _isPanelVisible ? 0 : -60, // Slide up and down
// //             child: Container(
// //               color: Colors.red,
// //               height: 60,
// //               child: Center(
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     // Add to cart logic
// //                   },
// //                   child: Text("Add to Cart"),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class DatePickerExample extends StatefulWidget {
//   const DatePickerExample({super.key, this.restorationId});

//   final String? restorationId;

//   @override
//   State<DatePickerExample> createState() => _DatePickerExampleState();
// }

// class _DatePickerExampleState extends State<DatePickerExample> {
//   final DateTime _initialDate = DateTime.now();
//   DateTime _selectedDate = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: OutlinedButton(
//           onPressed: () {
//             showDatePicker(
//               context: context,
//               initialDate: _selectedDate,
//               firstDate: _initialDate,
//               lastDate: _initialDate.add(const Duration(days: 365)),
//             ).then((DateTime? value) {
//               if (value != null) {
//                 setState(() {
//                   _selectedDate = value;
//                 });
//               }
//             });
//           },
//           child: const Text('Open Date Picker'),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//               'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
//         ));
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NestedScrollViewExample extends StatelessWidget {
  const NestedScrollViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Tab 1', 'Tab 2'];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text('Books'),
                  pinned: true,
                  // expandedHeight: 150.0,
                  // forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                  floating: true,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: 48.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListTile(
                                  title: Text('Item $index'),
                                );
                              },
                              childCount: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
