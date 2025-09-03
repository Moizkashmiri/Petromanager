import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuleflowpro/utils/AppColors.dart';
import 'package:provider/provider.dart';

import 'Providers/LoginProvider.dart';
import 'SplashScreen.dart';
import 'auth/LoginScreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(380, 790),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'FuelFlow Pro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
