import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/social-media/create_post_options.dart';

class CreatePostSheet extends StatefulWidget {
  final MyUser userData;
  const CreatePostSheet({super.key, required this.userData});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController _postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  void _handlePostOptions(int index) {
    switch (index) {
      case 0:
        _pickImageFromGallery();
        break;
      case 1:
        _takePhoto();
        break;
      default:
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to take a photo with the camera
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitPost(BuildContext context) {
    final post = MyPost(
      userId: widget.userData.userId,
      postId: "123",
      dateCreated: DateTime.now(),
      content: _postTextController.text.trim().isEmpty
          ? ""
          : _postTextController.text,
      imageUrl: _image == null ? "" : _image!.path,
    );
    BlocProvider.of<PostBloc>(context).add(AddPost(post: post));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:
                  _postTextController.text.trim().isEmpty && _image == null
                      ? null
                      : () => _submitPost(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Post'),
            ),
          ),
        ],
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildUserProfileRow(),
              const SizedBox(height: 20),
              buildPostTextField(),
              const SizedBox(height: 20),
              buildPostImage(),
              const SizedBox(height: 20),
              CreatePostOptions(
                onFunctionCallback: _handlePostOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserProfileRow() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.userData.profileImageUrl),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${widget.userData.firstName} ${widget.userData.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPostTextField() {
    return TextField(
      controller: _postTextController,
      keyboardType: TextInputType.multiline,
      maxLines: 8,
      decoration: InputDecoration.collapsed(
        hintText: 'What\'s on your mind, ${widget.userData.firstName}?',
        hintStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
      ),
      style: const TextStyle(fontSize: 20),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget buildPostImage() {
    return _image != null
        ? Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(FontAwesomeIcons.trashCan),
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                },
              ),
            ],
          )
        : const SizedBox();
  }
}
