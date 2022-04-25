import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reminder_app/data/db/db_helper.dart';
import 'package:reminder_app/service/theme_service.dart';
import 'package:reminder_app/ui/home/home_screen.dart';
import 'package:reminder_app/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyAppThemeConfig.light().getTheme(),
      darkTheme: MyAppThemeConfig.dark().getTheme(),
      themeMode: ThemeService().theme,
      home: const HomeScreen(),
    );
  }
}
