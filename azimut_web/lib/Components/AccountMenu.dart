import 'package:azimut_web/Constants/AppSection.dart';
import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:azimut_web/Helpers/CookieHelpers.dart';
import 'package:azimut_web/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({
    super.key,
    required this.selected,
    required this.onSelected,
    this.compact = false,
  });

  final AppSection selected;
  final ValueChanged<AppSection> onSelected;
  final bool compact;

  static const _sections = [
    AppSection.favorites,
    AppSection.comparison,
    AppSection.admissions,
  ];

  @override
  Widget build(BuildContext context) {
    final active = _sections.contains(selected);
    return PopupMenuButton<AppSection>(
      tooltip: 'Аккаунт',
      initialValue: active ? selected : null,
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 10),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      constraints: const BoxConstraints(minWidth: 256),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: ColorsApp.graphite.withValues(alpha: 0.08)),
      ),
      itemBuilder: (_) => [
        for (final section in _sections)
          PopupMenuItem(
            value: section,
            height: 52,
            child: Row(
              children: [
                Icon(section.icon, size: 20, color: ColorsApp.graphite),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      color: ColorsApp.graphite,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (section == selected)
                  const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: ColorsApp.chalkGreen,
                  ),
              ],
            ),
          ),
        const PopupMenuDivider(),
        if (CookieHelpers.HasToken())
          PopupMenuItem<AppSection>(
            onTap: CookieHelpers.RemoveToken,
            child: const Text('Выйти'),
          )
        else ...[
          PopupMenuItem<AppSection>(
            onTap: () => Navigator.of(context).pushNamed(Routes.login),
            child: const Text('Войти'),
          ),
          PopupMenuItem<AppSection>(
            onTap: () => Navigator.of(context).pushNamed(Routes.register),
            child: const Text('Зарегистрироваться'),
          ),
        ],
      ],
      child: Container(
        constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: active
                  ? ColorsApp.chalkGreen
                  : ColorsApp.notebook,
              foregroundColor: active ? Colors.white : ColorsApp.chalkGreen,
              child: const Icon(Icons.person_outline_rounded, size: 17),
            ),
            if (!compact) ...[
              const SizedBox(width: 9),
              const Text(
                'Аккаунт',
                style: TextStyle(
                  color: ColorsApp.graphite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 9),
              SvgPicture.asset(
                'assets/navigation/chevron-down.svg',
                excludeFromSemantics: true,
                colorFilter: const ColorFilter.mode(
                  ColorsApp.muted,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
