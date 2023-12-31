import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story/bloc/app_bloc.dart';
import 'package:instagram_story/bloc/story_bloc.dart';
import 'package:instagram_story/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    StoryBloc storyBloc = StoryBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc(storyBloc: storyBloc)),
        BlocProvider.value(value: storyBloc),
      ],
      child: MaterialApp(
        title: 'Instagram Story',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
