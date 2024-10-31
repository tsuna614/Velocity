import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/message_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/social-media/message/message_bubble.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key, required this.receiverData});

  final UserModel receiverData;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Connect to WebSocket server
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse(GlobalData.socketUrl).replace(queryParameters: {
      "userId": GlobalData.userId,
    }),
  );

  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<int> _notifier = ValueNotifier(-1);
  final _scrollController = ScrollController();
  List<MessageModel> messages = [];

  String getConversationId() {
    final String user1 = GlobalData.userId;
    final String user2 = widget.receiverData.userId;
    return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
  }

  Future<void> fetchAllMessages() async {
    final dio = Dio();
    final Response response =
        await dio.get('${GlobalData.baseUrl}/message/${getConversationId()}');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      setState(() {
        messages.addAll(data.map((e) => MessageModel.fromJson(e)));
        scrollToBottom();
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  void sendMessage(String value) {
    final newMessage = MessageModel(
      conversationId: "placeholder",
      message: value,
      sender: GlobalData.userId,
      receiver: widget.receiverData.userId,
      time: DateTime.now(),
    );
    channel.sink.add(json.encode(newMessage.toJson()));
    _textController.clear();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
  }

  @override
  void initState() {
    fetchAllMessages();
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.receiverData.firstName} ${widget.receiverData.lastName}',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Display messages
          Expanded(
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  messages.add(MessageModel.fromJson(
                      json.decode(snapshot.data.toString())));
                  // messages.add(MessageModel.fromJson(snapshot.data)); // This line will throw an error

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }

                return ValueListenableBuilder(
                    valueListenable: _notifier,
                    builder: (context, value, child) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (_notifier.value == index) {
                                _notifier.value = -1;
                              } else {
                                _notifier.value = index;
                              }
                            },
                            child: MessageBubble(
                              message: messages[index].message,
                              isCurrentUser:
                                  messages[index].sender == GlobalData.userId,
                              isChosenMessage: _notifier.value == index,
                              createdTime: messages[index].time,
                            ),
                          );
                        },
                      );
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Send a message'),
              onSubmitted: (value) {
                sendMessage(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
