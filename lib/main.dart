import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tell_bro/controller/db_helper.dart';
import 'package:tell_bro/model/theme_services.dart';
import 'package:tell_bro/view/home_page.dart';

import 'model/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.intiDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tell Bro',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const HomePage(),
    );
  }
}

