import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_app/src/api/user_api.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.originalUserData});

  final MyUser originalUserData;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _loginForm = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final UserApi userApi = UserApi();
  bool _isLoading = false;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  final double _avatarRadius = 65;

  @override
  void initState() {
    _firstNameController.text = widget.originalUserData.firstName;
    _lastNameController.text = widget.originalUserData.lastName;
    _emailController.text = widget.originalUserData.email;
    _phoneController.text = widget.originalUserData.phone;
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Pick image from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCancelPressed() {
    setState(() {
      _firstNameController.text = widget.originalUserData.firstName;
      _lastNameController.text = widget.originalUserData.lastName;
      _emailController.text = widget.originalUserData.email;
      _phoneController.text = widget.originalUserData.phone;
      _image = null;
    });
  }

  bool hasTextFieldsChanges() {
    return _firstNameController.text != widget.originalUserData.firstName ||
        _lastNameController.text != widget.originalUserData.lastName ||
        _emailController.text != widget.originalUserData.email ||
        _phoneController.text != widget.originalUserData.phone;
  }

  Future<void> _saveChanges(BuildContext context) async {
    // Validate the form
    final isValid = _loginForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _loginForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    // check if user have uploaded a new image first, then upload it, returning the url from the server
    String newProfileImageUrl =
        _image != null ? await userApi.uploadAvatar(image: _image!) : "";

    // update the user data where changed
    MyUser newUser = widget.originalUserData;
    newUser = newUser.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      profileImageUrl: _image != null
          ? newProfileImageUrl
          : widget.originalUserData.profileImageUrl,
    );

    // call event to upload the changes onto the server and update the user's state
    if (context.mounted) {
      BlocProvider.of<UserBloc>(context).add(UpdateUser(user: newUser));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: _avatarRadius,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              Center(child: buildAvatar()),
            ],
          ),
          buildTextFormField(context),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            buildCancelAndSaveButton(context),
        ],
      ),
    );
  }

  Widget buildAvatar() {
    return Stack(
      children: [
        Container(
          width: _avatarRadius * 2,
          height: _avatarRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white, // Border color
              width: 4.0, // Border width
            ),
          ),
          child: _image != null
              ? ClipOval(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.originalUserData.profileImageUrl.isNotEmpty
                        ? widget.originalUserData.profileImageUrl
                        : "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg",
                    // scale: 20,
                  ),
                  radius: 60,
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              _showImagePickerDialog(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextFormField(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _loginForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'First name',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
                TextFormField(
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Last name',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
                TextFormField(
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email address',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
                TextFormField(
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phone number',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
                TextFormField(
                  onChanged: (e) {
                    setState(() {});
                  },
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCancelAndSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
              child: ElevatedButton(
                onPressed: !hasTextFieldsChanges() && _image == null
                    ? null
                    : () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Revert all changes?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _onCancelPressed();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.transparent),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0),
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 8.0),
              child: ElevatedButton(
                onPressed: !hasTextFieldsChanges() && _image == null
                    ? null
                    : () async {
                        await _saveChanges(context);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                style: ButtonStyle(
                  // minimumSize: WidgetStatePropertyAll(Size.fromHeight(20)),
                  backgroundColor: !hasTextFieldsChanges() && _image == null
                      ? WidgetStateProperty.all<Color>(Colors.grey.shade300)
                      : WidgetStateProperty.all<Color>(Colors.blue),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                          color: !hasTextFieldsChanges() && _image == null
                              ? Colors.grey.shade300
                              : Colors.blue),
                    ),
                  ),
                ),
                child: _isLoading == false
                    ? Text(
                        'SAVE',
                        style: TextStyle(
                            letterSpacing: 5,
                            color: !hasTextFieldsChanges() && _image == null
                                ? Colors.grey
                                : Colors.white),
                      )
                    : const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
