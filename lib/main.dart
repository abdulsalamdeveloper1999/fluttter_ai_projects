import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midjourney/features/prompt/bloc/prompt_bloc.dart';
import 'package:flutter_midjourney/features/repos/repo.dart';

import 'features/prompt/ui/create_prompt_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromptBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey.shade900,
            elevation: 0,
          ),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey.shade900,
        ),
        home: const CreatePromptScreen(),
      ),
    );
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            BlocRepo()
                .generateImage('Create a magical scene with Disney princesses')
                .then((value) {
              log(value.toString());
            }).onError((error, stackTrace) {
              log(error.toString());
            });
          },
          child: const Text('Generate'),
        ),
      ),
    );
  }
}
