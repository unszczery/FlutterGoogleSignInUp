import 'package:flutter/material.dart';
//import 'package:news_getter/presentation/authorization/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:news_getter/presentation/authorization/sign_up.dart';
import 'package:news_getter/presentation/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SignIn"),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UnAuthenticated) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign In",
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
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      border: OutlineInputBorder(),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length < 8
                                          ? "Enter more than 8 characters"
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      border: OutlineInputBorder(),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length < 6
                                          ? "Enter min. 6 characters"
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _authenticateWithEmailAndPassword(
                                              context);
                                        },
                                        child: const Text("Sign In")),
                                  )
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _authenticateWithGoogle(context);
                            },
                            icon: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const Text("Don't have an account?"),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text("Sign Up")),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Container();
            },
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(GoogleSignInEvent());
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(SignInEvent(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
