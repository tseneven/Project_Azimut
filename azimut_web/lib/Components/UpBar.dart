import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpBar extends StatelessWidget {
  const UpBar({
    super.key,
    this.onMenuPressed,
    required this.onHome,
    this.accountMenu,
    this.brandAsset = 'assets/navigation/navigation.svg',
  });

  final VoidCallback onHome;
  final Widget? accountMenu;
  final String brandAsset;
  final VoidCallback? onMenuPressed;

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Azimut'),
        content: const Text(
          'Azimut помогает абитуриентам находить и сравнивать программы вузов и колледжей, подбирать варианты по баллам и планировать поступление.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return Material(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorsApp.border)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 32),
            child: SizedBox(
              height: compact ? 56 : 76,
              child: Row(
                children: [
                  TextButton(
                    onPressed: onHome,
                    style: TextButton.styleFrom(
                      foregroundColor: ColorsApp.graphite,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 44),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: ColorsApp.chalkGreen,
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: SizedBox.square(
                            dimension: 30,
                            child: Center(
                              child: SvgPicture.asset(
                                brandAsset,
                                excludeFromSemantics: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        const Text(
                          'Azimut',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!compact) ...[
                    const Text(
                      'Образование начинается с выбора',
                      style: TextStyle(color: ColorsApp.muted, fontSize: 12),
                    ),
                    const Spacer(),
                  ],
                  if (!compact || accountMenu == null)
                    TextButton(
                      onPressed: () => _showAbout(context),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorsApp.graphite,
                      ),
                      child: const Text('О проекте'),
                    ),
                  if (!compact && accountMenu != null)
                    const SizedBox(width: 20),
                  if (accountMenu case final menu?) menu,
                  if (compact && onMenuPressed != null)
                    IconButton(
                      tooltip: 'Открыть меню',
                      onPressed: onMenuPressed,
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: ColorsApp.graphite,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
