import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:news_getter/presentation/authorization/sign_in.dart';

import '../home_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SignUp"),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UnAuthenticated) {
              return Center(
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Center(
                              child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        border: OutlineInputBorder()),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null &&
                                              EmailValidator.validate(value)
                                          ? 'Enter a valid email'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                        hintText: "Password",
                                        border: OutlineInputBorder()),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null &&
                                              value.toString().length < 8
                                          ? 'The password should contains at least 8 characters'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _createAccountWithEmailAndPassword(
                                            context);
                                      },
                                      child: const Text("Sign Up"),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                            const Text("Already have an account?"),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignIn()));
                              },
                              child: const Text("Sign in"),
                            ),
                            const Text("Or"),
                            IconButton(
                              onPressed: () {
                                _authenticateWithGoogle(context);
                              },
                              icon: Image.network(
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                                height: 20,
                                width: 20,
                              ),
                            )
                          ],
                        ),
                      )));
            }
            return Container();
          },
        ));
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(SignUpEvent(
          email: _emailController.text, password: _passwordController.text));
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInEvent(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
