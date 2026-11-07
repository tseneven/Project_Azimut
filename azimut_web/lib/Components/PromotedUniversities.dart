import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';

class PromotedUniversities extends StatelessWidget {
  const PromotedUniversities({super.key, required this.onOpenCatalog});

  final VoidCallback onOpenCatalog;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Знакомьтесь с вузами',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                'Партнёрские предложения · демонстрационные карточки',
                style: TextStyle(color: ColorsApp.muted, fontSize: 13),
              ),
            ],
          ),
          TextButton(
            onPressed: onOpenCatalog,
            child: const Text('В каталог вузов'),
          ),
        ],
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, constraints) {
          const gap = 20.0;
          final width = constraints.maxWidth >= 650
              ? (constraints.maxWidth - gap) / 2
              : constraints.maxWidth;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final (city, title, photo) in const [
                (
                  'Екатеринбург',
                  'Северный университет технологий',
                  'assets/landing/northern-university.png',
                ),
                (
                  'Казань',
                  'Институт городской среды',
                  'assets/landing/urban-institute.png',
                ),
              ])
                SizedBox(
                  width: width,
                  child: _PromotionCard(
                    city: city,
                    title: title,
                    photo: photo,
                    onOpenCatalog: onOpenCatalog,
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({
    required this.city,
    required this.title,
    required this.photo,
    required this.onOpenCatalog,
  });

  final String city;
  final String title;
  final String photo;
  final VoidCallback onOpenCatalog;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: ColorsApp.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          photo,
          height: 148,
          fit: BoxFit.cover,
          excludeFromSemantics: true,
          errorBuilder: (_, _, _) => const SizedBox(
            height: 148,
            child: ColoredBox(color: ColorsApp.periwinkle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$city · вымышленный вуз',
                      style: const TextStyle(
                        color: ColorsApp.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorsApp.notebook,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Text('Реклама', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onOpenCatalog,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('Смотреть каталог программ'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
