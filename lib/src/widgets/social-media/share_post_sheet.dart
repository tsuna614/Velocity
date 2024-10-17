import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/widgets/social-media/avatar_and_name.dart';

class SharePostSheet extends StatefulWidget {
  const SharePostSheet({super.key, required this.postData});

  final MyPost postData;

  @override
  State<SharePostSheet> createState() => _SharePostSheetState();
}

class _SharePostSheetState extends State<SharePostSheet> {
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _onSubmit() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }

    MyPost newPost = MyPost(
      postId: "",
      userId: GlobalData.userId,
      dateCreated: DateTime.now(),
      content: _textEditingController.text,
      sharedPostId: widget.postData.postId,
    );

    if (context.mounted) {
      BlocProvider.of<PostBloc>(context).add(AddPost(post: newPost));
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const AvatarAndName(),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Write something about this',
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, right: 10.0),
                          child: InkWell(
                            onTap: _onSubmit,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Share',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
