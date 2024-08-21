import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/events.dart';
import 'package:velocity_app/src/bloc/states.dart';
import 'package:velocity_app/src/bloc/user_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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

    // Call the API to sign in the user
    BlocProvider.of<UserBloc>(context).add(
      SignUp(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );

    // Wait for the result and return the first element of this stream matching UserSuccess or UserFailure
    final result = await BlocProvider.of<UserBloc>(context).stream.firstWhere(
          (state) => state is UserSuccess || state is UserFailure,
        );
    if (!context.mounted) return;

    // Handle result
    if (result is UserSuccess) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((result as UserFailure).message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 72, 105),
        body: Stack(
          children: [
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
                              'Sign In',
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
        ));
  }

  Widget buildSignUpForm() {
    return Form(
      key: _loginForm,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Email address',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              prefixIcon: const Icon(
                Icons.mail_outline,
                color: Colors.white,
              ),
              hintText: 'Enter your email address',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              prefixIcon: const Icon(
                Icons.key,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  value.trim().length < 6) {
                return 'Please enter a valid password';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Confirm Password',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _confirmPasswordController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              prefixIcon: const Icon(
                Icons.key,
                color: Colors.white,
              ),
              hintText: 'Confirm your password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
