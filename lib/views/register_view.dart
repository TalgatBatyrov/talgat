import 'dart:developer' as devtools show log;
import 'package:basic_registration/constants/routes.dart';
import 'package:basic_registration/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email here',
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password here',
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          devtools.log(userCredential.toString());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            await showErrorDialog(
                              context,
                              'Email already in use',
                            );
                          } else if (e.code == 'invalid-email') {
                            await showErrorDialog(
                              context,
                              'Invalid email',
                            );
                          } else if (e.code == 'weak-password') {
                            await showErrorDialog(
                              context,
                              'Weak password',
                            );
                          } else {
                            await showErrorDialog(
                              context,
                              'Error: ${e.code}',
                            );
                          }
                        } catch (e) {
                          await showErrorDialog(
                            context,
                            e.toString(),
                          );
                        }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      child: const Text('Already register? Login here!'),
                    ),
                  ],
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }
}
