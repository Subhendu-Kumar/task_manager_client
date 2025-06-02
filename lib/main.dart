import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_client/my_app.dart';
import 'package:task_manager_client/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager_client/features/home/cubit/tasks_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => TasksCubit()),
      ],
      child: const MyApp(),
    ),
  );
}
