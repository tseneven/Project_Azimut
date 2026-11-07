import 'package:azimut_web/Components/PromotedUniversities.dart';
import 'package:azimut_web/Components/UniversityBanner.dart';
import 'package:azimut_web/Constants/AppSection.dart';
import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.onSelected});

  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Ваш выбор. Ваше будущее.',
        style: TextStyle(color: ColorsApp.muted, fontSize: 13),
      ),
      const SizedBox(height: 18),
      LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final intro = _Intro(
            wide: wide,
            onMatch: () => onSelected(AppSection.matching),
          );
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                intro,
                const SizedBox(height: 22),
                const UniversityBanner(),
              ],
            );
          }
          return Row(
            children: [
              Expanded(flex: 5, child: intro),
              const SizedBox(width: 30),
              const Expanded(flex: 7, child: UniversityBanner()),
            ],
          );
        },
      ),
      const SizedBox(height: 24),
      LayoutBuilder(
        builder: (context, constraints) {
          const gap = 16.0;
          final width = constraints.maxWidth >= 660
              ? (constraints.maxWidth - gap * 2) / 3
              : constraints.maxWidth;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final (section, subtitle, icon) in const [
                (
                  AppSection.universities,
                  'Бакалавриат и специалитет',
                  'quick-graduation-cap',
                ),
                (
                  AppSection.colleges,
                  'После 9-го и 11-го класса',
                  'quick-school',
                ),
                (
                  AppSection.admissions,
                  'Сроки, документы и ваши шаги',
                  'quick-clipboard-list',
                ),
              ])
                SizedBox(
                  width: width,
                  child: _QuickLink(
                    section: section,
                    subtitle: subtitle,
                    icon: icon,
                    onTap: () => onSelected(section),
                  ),
                ),
            ],
          );
        },
      ),
      const SizedBox(height: 28),
      PromotedUniversities(
        onOpenCatalog: () => onSelected(AppSection.universities),
      ),
      const SizedBox(height: 24),
      _FamilyPanel(onCompare: () => onSelected(AppSection.comparison)),
      const SizedBox(height: 22),
      const Text(
        'Актуальные правила приёма, стоимость и сроки уточняйте на официальном сайте учреждения.',
        style: TextStyle(color: ColorsApp.muted, fontSize: 12, height: 1.4),
      ),
    ],
  );
}

class _Intro extends StatelessWidget {
  const _Intro({required this.wide, required this.onMatch});

  final bool wide;
  final VoidCallback onMatch;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(
          'Найдите свой путь\nв образование',
          style: TextStyle(
            fontSize: wide ? 48 : 36,
            height: 1.06,
            letterSpacing: wide ? -2.2 : -1.3,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      const SizedBox(height: 23),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420),
        child: Text(
          'От ваших баллов — к понятным вариантам. Выберите вуз или колледж, сравните условия и спланируйте поступление.',
          style: TextStyle(color: ColorsApp.muted, fontSize: 16, height: 1.65),
        ),
      ),
      const SizedBox(height: 23),
      FilledButton.icon(
        onPressed: onMatch,
        icon: SvgPicture.asset(
          'assets/navigation/arrow-right.svg',
          excludeFromSemantics: true,
        ),
        label: const Text('Подобрать по баллам'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(height: 23),
      const Text(
        'По ЕГЭ или среднему баллу аттестата',
        style: TextStyle(color: ColorsApp.muted, fontSize: 12),
      ),
    ],
  );
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.section,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final AppSection section;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: ColorsApp.border),
    ),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: SvgPicture.asset(
        'assets/navigation/$icon.svg',
        colorFilter: const ColorFilter.mode(
          ColorsApp.chalkGreen,
          BlendMode.srcIn,
        ),
        excludeFromSemantics: true,
      ),
      trailing: const Text(
        '↗',
        style: TextStyle(color: ColorsApp.chalkGreen, fontSize: 20),
      ),
      title: Text(
        section.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: ColorsApp.muted, fontSize: 12),
      ),
    ),
  );
}

class _FamilyPanel extends StatelessWidget {
  const _FamilyPanel({required this.onCompare});

  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Color.alphaBlend(
        ColorsApp.highlighter.withValues(alpha: 0.22),
        ColorsApp.notebook,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 620;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Хороший выбор проще сделать вместе',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Сохраните интересные программы и сравните стоимость, города и условия обучения с родителями.',
              style: TextStyle(color: ColorsApp.muted, height: 1.6),
            ),
            TextButton(
              onPressed: onCompare,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('К сравнению'),
            ),
          ],
        );
        final photo = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/landing/family.png',
            width: wide ? 260 : double.infinity,
            height: 124,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
        );
        return Flex(
          direction: wide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: wide
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          spacing: wide ? 24 : 12,
          children: [
            wide ? Expanded(child: copy) : copy,
            photo,
          ],
        );
      },
    ),
  );
}
