import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/bloc/user/user_bloc.dart';
import 'package:velocity_app/src/view/auth/sign_up.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;

  void _submitForm() async {
    // Validate the form
    final isValid = _loginForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _loginForm.currentState!.save();

    // Close the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isLoading = true;
    });

    // Call the API to sign in the user
    BlocProvider.of<UserBloc>(context).add(
      SignIn(
        email: _usernameController.text,
        password: _passwordController.text,
      ),
    );

    // Wait for the result and return the first element of this stream matching UserSuccess or UserFailure
    final result = await BlocProvider.of<UserBloc>(context).stream.firstWhere(
          (state) => state is UserSuccess || state is UserFailure,
        );

    // Show a snackbar with the result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result is UserSuccess
              ? 'Sign in successful'
              : (result as UserFailure).message,
        ),
        backgroundColor: result is UserSuccess ? Colors.green : Colors.red,
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SignUpScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // push transition
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
                        const SizedBox(
                          height: 50,
                        ),
                        // Image.asset(
                        //   'assets/images/app/logo2.png',
                        //   color: Colors.white,
                        //   width: 250,
                        // ),
                        const SizedBox(height: 50),
                        buildLoginForm(),
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 20),
                        const Text(
                          '- O R -',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        buildSignInWithOtherPlatformsButtons(),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            _navigateToSignUp(context);
                          },
                          child: const Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(text: 'Don\'t have an account? '),
                                TextSpan(
                                  text: 'Sign Up.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
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

  Widget buildLoginForm() {
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
            onSaved: (newValue) => _usernameController.text = newValue!,
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
            onSaved: (newValue) => _passwordController.text = newValue!,
          ),
        ],
      ),
    );
  }

  Widget buildSignInWithOtherPlatformsButtons() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () async {},
          child: Ink(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.google,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () {},
          child: Ink(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.facebook,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Sign in with Facebook',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
