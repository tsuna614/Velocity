import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/model/user_model.dart';

class DetailSignUpScreen extends StatefulWidget {
  const DetailSignUpScreen(
      {super.key, required this.enteredEmail, required this.enteredPassword});

  final String enteredEmail;
  final String enteredPassword;

  @override
  State<DetailSignUpScreen> createState() => _DetailSignUpScreenState();
}

class _DetailSignUpScreenState extends State<DetailSignUpScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  var _isLoading = false;

  void _submitForm() async {
    // Validate the form
    final isValid = _loginForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _loginForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    final MyUser user = MyUser(
      userId:
          "", // set a temporary userId, when post to backend mongodb will automatically generate an _id
      email: widget.enteredEmail,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneNumberController.text,
      profileImageUrl: "",
    );

    // Call the API to sign in the user
    BlocProvider.of<UserBloc>(context).add(
      SignUp(
        user: user,
        password: widget.enteredPassword,
      ),
    );

    // Wait for the result and return the first element of this stream matching UserSuccess or UserFailure
    final result = await BlocProvider.of<UserBloc>(context).stream.firstWhere(
          (state) => state is UserLoaded || state is UserFailure,
        );

    // Handle result
    if (!mounted) return;
    if (result is UserLoaded) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((result as UserFailure).message),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 72, 105),
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: buildPagePopButton(),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Last step.',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Tell us more about yourself.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 60),
                          buildSignUpForm(),
                          const SizedBox(height: 60),
                          if (_isLoading)
                            const CircularProgressIndicator()
                          else
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(40)),
                              onPressed: _submitForm,
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 28, 112),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildPagePopButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            Text(
              "Sign in",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignUpForm() {
    return Form(
      key: _loginForm,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'First Name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _firstNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your first name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Invalid first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Last Name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _lastNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your last name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Invalid last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone Number',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _phoneNumberController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your phone number',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Invalid phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
