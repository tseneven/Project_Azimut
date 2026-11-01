import 'package:flutter/material.dart';
import 'Routes.dart';

class MaterialAppFrame extends StatelessWidget {
  const MaterialAppFrame({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Azimut',
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: Routes.routes,
  );
}
