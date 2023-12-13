import 'package:bloc_api_integration/bloc/task_bloc.dart';
import 'package:bloc_api_integration/bloc/task_event.dart';
import 'package:bloc_api_integration/bloc/todo_bloc.dart';
import 'package:bloc_api_integration/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TodoBloc(),
          ),
          BlocProvider(
            create: (context) => TaskBloc()..add(LoadTasks()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TaskScreen(),
        ));
  }
}
