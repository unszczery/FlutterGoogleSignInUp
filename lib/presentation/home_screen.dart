import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:news_getter/presentation/authorization/sign_In.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('News Getter'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false);
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  user.photoURL != null
                      ? Image.network("${user.photoURL}")
                      : Container(),
                  user.displayName != null
                      ? Text("${user.displayName}")
                      : Container(),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                      child: const Text('Sign Out'))
                ],
              ),
            )));
  }
}
