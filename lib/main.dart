import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:posrem_webapp/firebase_options.dart';
import 'package:posrem_webapp/presentation/page/myapp.dart';
import 'package:posrem_webapp/presentation/provider/add_user_provider.dart';
import 'package:posrem_webapp/presentation/provider/detailuser_provider.dart';
import 'package:posrem_webapp/presentation/provider/list_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailuserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddUserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
