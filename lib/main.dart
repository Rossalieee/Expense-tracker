import 'package:expense_tracker/color_schemes.g.dart';
import 'package:expense_tracker/objectbox_store.dart';
import 'package:expense_tracker/root_page/root_page.dart';
import 'package:flutter/material.dart';


late ObjectBox objectbox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const RootPage(),
    );
  }
}
