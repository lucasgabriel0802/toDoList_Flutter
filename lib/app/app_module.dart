import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/app_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider.dart' as auth_provider;
import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository_impl.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';
import 'package:todo_list_provider/app/services/user/user_service_impl.dart';

class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => firebase_auth.FirebaseAuth.instance),
        Provider(create: (_) => SqliteConnectionFactory(), lazy: false),
        Provider<UserRepository>(
            create: (context) => UserRepositoryImpl(firebaseAuth: context.read())),
        Provider<UserService>(create: (context) => UserServiceImpl(userRepository: context.read())),
        ChangeNotifierProvider(
          create: (context) => auth_provider.AuthProvider(
            firebaseAuth: context.read(),
            userService: context.read(),
          )..loadListener(),
          lazy: false,
        ),
      ],
      child: const AppWidget(),
    );
  }
}
