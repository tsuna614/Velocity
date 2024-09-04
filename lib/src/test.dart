// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';

// // class TestScreen extends StatefulWidget {
// //   @override
// //   _TestScreenState createState() => _TestScreenState();
// // }

// // class _TestScreenState extends State<TestScreen> {
// //   final ScrollController _scrollController = ScrollController();
// //   int _selectedIndex = 0;

// //   void _scrollToIndex(int index) {
// //     _scrollController.animateTo(
// //       index * 200.0, // Each container is 200px in height
// //       duration: const Duration(seconds: 1),
// //       curve: Curves.easeInOut,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Scroll to Index Example'),
// //       ),
// //       body: Column(
// //         children: [
// //           DropdownButton<int>(
// //             value: _selectedIndex,
// //             items: List.generate(50, (index) {
// //               return DropdownMenuItem(
// //                 value: index,
// //                 child: Text('Item ${index + 1}'),
// //               );
// //             }),
// //             onChanged: (int? value) {
// //               if (value != null) {
// //                 setState(() {
// //                   _selectedIndex = value;
// //                 });
// //                 _scrollToIndex(value);
// //               }
// //             },
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               controller: _scrollController,
// //               itemCount: 50,
// //               itemBuilder: (context, index) {
// //                 return Container(
// //                   height: 200,
// //                   color: index % 2 == 0 ? Colors.blue : Colors.green,
// //                   child: Center(
// //                     child: Text(
// //                       'Item ${index + 1}',
// //                       style: const TextStyle(fontSize: 24, color: Colors.white),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// class TestScreen extends StatefulWidget {
//   const TestScreen({Key? key, this.title}) : super(key: key);
//   final String? title;

//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> {
//   final controller = ScrollController();
//   OverlayEntry? sticky;
//   GlobalKey stickyKey = GlobalKey();

//   @override
//   void initState() {
//     sticky?.remove();

//     sticky = OverlayEntry(
//       builder: (context) => stickyBuilder(context),
//     );

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       if (sticky != null) {
//         Overlay.of(context).insert(sticky!);
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     sticky?.remove();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: ListView.builder(
//         controller: controller,
//         itemBuilder: (context, index) {
//           if (index == 6) {
//             return Container(
//               key: stickyKey,
//               height: 100.0,
//               color: Colors.green,
//               child: const Text("I'm fat"),
//             );
//           }
//           return ListTile(
//             title: Text(
//               'Hello $index',
//               style: const TextStyle(color: Colors.white),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget stickyBuilder(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         final keyContext = stickyKey.currentContext;
//         if (keyContext != null) {
//           // widget is visible
//           final box = keyContext.findRenderObject() as RenderBox;
//           final pos = box.localToGlobal(Offset.zero);
//           return Positioned(
//             top: pos.dy + box.size.height,
//             left: 50.0,
//             right: 50.0,
//             height: box.size.height,
//             child: Material(
//               child: Container(
//                 alignment: Alignment.center,
//                 color: Colors.purple,
//                 child: const Text("^ Nah I think you're okay"),
//               ),
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   }
// }
