import 'package:azimut_web/Constants/AppSection.dart';
import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeftBar extends StatelessWidget {
  const LeftBar({super.key, required this.selected, required this.onSelected});

  final AppSection selected;
  final ValueChanged<AppSection> onSelected;

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помощь'),
        content: const Text(
          'Начните с каталога вузов или колледжей либо подберите программы по своим результатам. '
          'Проходные баллы прошлых лет помогают ориентироваться. Актуальные условия уточняйте на сайте учебного заведения.',
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
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    child: Container(
      width: 224,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: ColorsApp.border)),
      ),
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
          children: [
            _item(AppSection.home, 'house'),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Text(
                'ПОИСК И ПОДБОР',
                style: TextStyle(
                  color: ColorsApp.muted,
                  fontSize: 10,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            _item(AppSection.universities, 'graduation-cap'),
            const SizedBox(height: 8),
            _item(AppSection.colleges, 'school'),
            const SizedBox(height: 8),
            _item(AppSection.calculator, 'calculator'),
            const SizedBox(height: 8),
            _item(AppSection.matching, 'sliders-horizontal'),
            const SizedBox(height: 8),
            Material(
              color: ColorsApp.notebook,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onSelected(AppSection.comparison),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выбираете вместе?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Сравните варианты и обсудите их с семьёй.',
                        style: TextStyle(
                          color: ColorsApp.muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'К сравнению →',
                        style: TextStyle(
                          color: ColorsApp.chalkGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _showHelp(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: ColorsApp.muted,
                  minimumSize: const Size(0, 40),
                ),
                child: const Text('Помощь', style: TextStyle(fontSize: 11)),
              ),
            ),
            const Text(
              '© Azimut',
              style: TextStyle(color: ColorsApp.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _item(AppSection section, String icon) {
    final active = selected == section;
    return Semantics(
      selected: active,
      button: true,
      child: Ink(
        decoration: BoxDecoration(
          color: active ? ColorsApp.chalkGreen.withValues(alpha: 0.09) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onSelected(section),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/navigation/$icon.svg',
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(
                    active ? ColorsApp.chalkGreen : ColorsApp.muted,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      color: active ? ColorsApp.chalkGreen : ColorsApp.graphite,
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
