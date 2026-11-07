import 'package:flutter/material.dart';
import 'Constants/ColorsApp.dart';
import 'Routes.dart';

class MaterialAppFrame extends StatelessWidget {
  const MaterialAppFrame({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Azimut',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: ColorsApp.chalkGreen,
        secondary: ColorsApp.periwinkle,
        onSecondary: ColorsApp.graphite,
        surface: Colors.white,
        onSurface: ColorsApp.graphite,
        error: ColorsApp.ruby,
        outlineVariant: ColorsApp.border,
      ),
      scaffoldBackgroundColor: ColorsApp.notebook,
    ),
    routes: Routes.routes,
  );
}
