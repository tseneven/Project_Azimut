import 'package:azimut_web/Constants/AppSection.dart';
import 'package:azimut_web/Components/LeftBar.dart';
import 'package:azimut_web/Components/AccountMenu.dart';
import 'package:azimut_web/Components/UpBar.dart';
import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'LandingPage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppSection _selected = AppSection.home;

  void _select(AppSection section) {
    setState(() => _selected = section);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      key: _scaffoldKey,
      drawer: desktop
          ? null
          : Drawer(
              width: 288,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: LeftBar(selected: _selected, onSelected: _select),
              ),
            ),
      body: Column(
        children: [
          UpBar(
            onHome: () => _select(AppSection.home),
            accountMenu: AccountMenu(
              selected: _selected,
              onSelected: _select,
              compact: !desktop,
            ),
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (desktop) LeftBar(selected: _selected, onSelected: _select),
                Expanded(
                  child: SingleChildScrollView(
                    key: ValueKey(_selected),
                    padding: EdgeInsets.all(desktop ? 32 : 20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: _selected == AppSection.home
                            ? LandingPage(onSelected: _select)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selected.title,
                                    style: const TextStyle(
                                      color: ColorsApp.graphite,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.7,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _selected.description,
                                    style: TextStyle(
                                      color: ColorsApp.muted,
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
