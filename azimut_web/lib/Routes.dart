import 'package:flutter/material.dart';
import 'Constants/ColorsApp.dart';

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (_) => Scaffold(backgroundColor: ColorsApp.backgroundBlack),
  };
}
