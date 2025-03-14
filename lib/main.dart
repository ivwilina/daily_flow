import 'package:dailyflow_prototype_2/database/db_helper.dart';
import 'package:dailyflow_prototype_2/services/notification_service.dart';
import 'package:dailyflow_prototype_2/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DbHelper.initDb();
  await NotifyHelper().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
      ),
      home: HomePage(),
    );
  }
}
