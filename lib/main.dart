import 'package:basic_registration/constants/routes.dart';
import 'package:basic_registration/services/auth/auth_service.dart';
import 'package:basic_registration/views/login_view.dart';
import 'package:basic_registration/views/notes/new_notes_view.dart';
import 'package:basic_registration/views/notes/notes_view.dart';
import 'package:basic_registration/views/register_view.dart';
import 'package:basic_registration/views/verify_email_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const HomePage(),
        loginRoute: (_) => const LoginView(),
        registerRoute: (_) => const RegisterView(),
        notesRoute: (_) => const NotesView(),
        verifyEmailRoute: (_) => const VerifyEmailView(),
        newNoteRoute: (_) => const NewNoteView(), 
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialise(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
