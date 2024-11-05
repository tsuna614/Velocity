// // // import 'package:flutter/material.dart';
// // // import 'package:video_player/video_player.dart';

// // // class VideoApp extends StatefulWidget {
// // //   const VideoApp({super.key});

// // //   @override
// // //   _VideoAppState createState() => _VideoAppState();
// // // }

// // // class _VideoAppState extends State<VideoApp> {
// // //   late VideoPlayerController _controller;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _controller = VideoPlayerController.networkUrl(Uri.parse(
// // //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
// // //       ..initialize().then((_) {
// // //         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
// // //         setState(() {});
// // //       });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Video Demo',
// // //       home: Scaffold(
// // //         body: Center(
// // //           child: _controller.value.isInitialized
// // //               ? GestureDetector(
// // //                   onTap: () {
// // //                     setState(() {
// // //                       _controller.value.isPlaying
// // //                           ? _controller.pause()
// // //                           : _controller.play();
// // //                     });
// // //                   },
// // //                   child: AspectRatio(
// // //                     aspectRatio: _controller.value.aspectRatio,
// // //                     child: VideoPlayer(_controller),
// // //                   ),
// // //                 )
// // //               : Container(),
// // //         ),
// // //         floatingActionButton: FloatingActionButton(
// // //           onPressed: () {
// // //             setState(() {
// // //               _controller.value.isPlaying
// // //                   ? _controller.pause()
// // //                   : _controller.play();
// // //             });
// // //           },
// // //           child: Icon(
// // //             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller.dispose();
// // //     super.dispose();
// // //   }
// // // }

// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_app/src/model/message_model.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketExample extends StatefulWidget {
//   @override
//   _WebSocketExampleState createState() => _WebSocketExampleState();
// }

// class _WebSocketExampleState extends State<WebSocketExample> {
//   // Connect to WebSocket server
//   final WebSocketChannel channel = WebSocketChannel.connect(
//     Uri.parse('ws://localhost:3000'),
//   );

//   final TextEditingController controller = TextEditingController();
//   List<String> messages = [];

//   Future<void> fetchAllMessages() async {
//     final dio = Dio();
//     final Response response = await dio.get('http://localhost:3000/message');

//     if (response.statusCode == 200) {
//       final List<dynamic> data = response.data;
//       setState(() {
//         messages.addAll(data.map((e) => e['message'].toString()));
//       });
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }

//   @override
//   void initState() {
//     fetchAllMessages();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('WebSocket Example')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Display messages
//             Expanded(
//               child: StreamBuilder(
//                 stream: channel.stream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     messages.add(snapshot.data.toString());
//                   }

//                   return ListView.builder(
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(messages[index]),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             TextField(
//               controller: controller,
//               decoration: InputDecoration(labelText: 'Send a message'),
//               onSubmitted: (value) {
//                 // Send message to the WebSocket server
//                 final newMessage = MessageModel(
//                   conversationId: "boilerplate",
//                   message: value,
//                   sender: "user1",
//                   receiver: "user2",
//                   time: DateTime.now(),
//                 );
//                 channel.sink.add(json.encode(newMessage.toJson()));
//                 controller.clear();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:velocity_app/l10n/app_localizations.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.welcomeMessage),
      ),
    );
  }
}
