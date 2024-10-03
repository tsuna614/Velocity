import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_app/src/bloc/post/post_states.dart';
import 'package:velocity_app/src/services/post_api.dart';
import 'package:velocity_app/src/bloc/post/post_bloc.dart';
import 'package:velocity_app/src/bloc/post/post_events.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/widgets/social-media/create_post_options.dart';

class CreatePostSheet extends StatefulWidget {
  final MyUser userData;
  final PostBloc? postBloc;
  final String? travelId;

  const CreatePostSheet({
    super.key,
    required this.userData,
    this.postBloc,
    this.travelId,
  });

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController _postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  double rating = 0;

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

  Future<void> _submitPost(BuildContext context) async {
    if (widget.travelId != null && rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please put a rating first.'),
        ),
      );
      return;
    }

    final post = MyPost(
      userId: widget.userData.userId,
      postId: "",
      dateCreated: DateTime.now(),
      content: _postTextController.text.trim().isEmpty
          ? ""
          : _postTextController.text,
      imageUrl: _image == null
          ? ""
          : await GetIt.I<PostApi>().uploadImage(image: _image!),
      travelId: widget.travelId,
      rating: widget.travelId == null ? null : rating,
    );
    if (context.mounted) {
      BlocProvider.of<PostBloc>(context).add(AddPost(post: post));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // if postBloc is passed in (which means its rating bloc, created in rating_page.dart)
      // use that instead of the default post bloc created in main.dart
      value: widget.postBloc == null
          ? BlocProvider.of<PostBloc>(context)
          : widget.postBloc!,
      child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
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
                  if (widget.travelId != null) buildRatingButtons(),
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
      }),
    );
  }

  Widget buildUserProfileRow() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            widget.userData.profileImageUrl.isNotEmpty
                ? widget.userData.profileImageUrl
                : "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg",
          ),
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

  Widget buildRatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            rating >= 1 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              rating = 1;
            });
          },
        ),
        IconButton(
          icon: Icon(
            rating >= 2 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              rating = 2;
            });
          },
        ),
        IconButton(
          icon: Icon(
            rating >= 3 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              rating = 3;
            });
          },
        ),
        IconButton(
          icon: Icon(
            rating >= 4 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              rating = 4;
            });
          },
        ),
        IconButton(
          icon: Icon(
            rating >= 5 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              rating = 5;
            });
          },
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
