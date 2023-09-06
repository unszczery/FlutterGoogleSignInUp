// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:news_getter/bloc/auth_bloc.dart';
// import 'package:news_getter/repository/auth_repository.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_getter/components/secure_storage.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({Key? key}) : super(key: key);

//   @override
//   AuthScreenState createState() => AuthScreenState();
// }

// class AuthScreenState extends State<AuthScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   late AuthBloc _authBloc;
//   late SecureStorage _secureStorage;
//   //late SharedPreferences _sharedPreferences;

//   @override
//   void initState() {
//     super.initState();
//     _secureStorage = SecureStorage();
//     _fetchSecureData();

//     ;
//   }

//   Future<void> _fetchSecureData() async {
//     _emailController.text = await _secureStorage.getUserEmail() ?? '';
//     _passwordController.text = await _secureStorage.getUserPassword() ?? '';
//     //print(_secureStorage.getUserPassword().toString());
//   }

//   Future<void> _initAuth() async {
//     _authBloc = AuthBloc(secureStorage: _secureStorage);
//     if (_authBloc.loggedIn) {
//       Navigator.of(context).pushReplacementNamed('/home');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//         future: _initAuth(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasError) {
//             return Scaffold(
//                 body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ));
//           } else {
//             return Scaffold(
//                 body: BlocProvider(
//                     create: (_) => _authBloc,
//                     child: BlocListener<AuthBloc, AuthState>(
//                         listener: (context, state) {
//                       if (state is AuthSuccess) {
//                         Navigator.of(context).pushReplacementNamed('/home');
//                       } else if (state is AuthFailure) {
//                         final snackBar =
//                             SnackBar(content: Text(state.errorMessage));
//                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                       }
//                     }, child: BlocBuilder<AuthBloc, AuthState>(
//                             builder: (context, state) {
//                       return Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             TextField(
//                               controller: _emailController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Email',
//                               ),
//                             ),
//                             TextField(
//                               controller: _passwordController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Password',
//                               ),
//                               obscureText: true,
//                             ),
//                             const SizedBox(height: 16.0),
//                             ElevatedButton(
//                               onPressed: () {
//                                 _authBloc.add(LoginEvent(
//                                     email: _emailController.text,
//                                     password: _passwordController.text));
//                               },
//                               child: const Text('Log in'),
//                             ),
//                             const SizedBox(height: 16.0),
//                             ElevatedButton(
//                                 onPressed: () async {
//                                   _authBloc.add(RegisterEvent(
//                                       email: _emailController.text,
//                                       password: _passwordController.text));
//                                 },
//                                 child: const Text('Register'))
//                           ],
//                         ),
//                       );
//                     }))));
//           }
//         });
//   }

//   @override
//   void dispose() {
//     _authBloc.close();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
