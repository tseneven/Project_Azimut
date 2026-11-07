import 'dart:async';

import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';

class UniversityBanner extends StatefulWidget {
  const UniversityBanner({super.key});

  @override
  State<UniversityBanner> createState() => _UniversityBannerState();
}

class _UniversityBannerState extends State<UniversityBanner> {
  static const _slideInterval = Duration(seconds: 6);
  static const _slides = [
    (
      photo: 'assets/msu.png',
      preview: 'assets/msu.png',
      shortName: 'МГУ',
      city: 'МОСКВА',
      name: 'МГУ имени М. В. Ломоносова',
    ),
    (
      photo: 'assets/landing/spbu.png',
      preview: 'assets/landing/spbu.png',
      shortName: 'СПбГУ',
      city: 'САНКТ-ПЕТЕРБУРГ',
      name: 'Санкт-Петербургский государственный университет',
    ),
    (
      photo: 'assets/urfu.png',
      preview: 'assets/urfu.png',
      shortName: 'УрФУ',
      city: 'ЕКАТЕРИНБУРГ',
      name: 'Уральский федеральный университет',
    ),
  ];

  final _controller = PageController();
  Timer? _autoplay;
  int _current = 0;
  bool? _playOverride;
  bool _hovered = false;

  bool get _playing =>
      _playOverride ?? !MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleAutoplay();
  }

  void _scheduleAutoplay() {
    _autoplay?.cancel();
    if (_playing && !_hovered) {
      _autoplay = Timer(_slideInterval, () => _goTo(_current + 1));
    }
  }

  Future<void> _goTo(int index) async {
    _autoplay?.cancel();
    if (!_controller.hasClients) return;
    await _controller.animateToPage(
      index % _slides.length,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOutCubic,
    );
    if (mounted) _scheduleAutoplay();
  }

  void _toggleAutoplay() {
    setState(() => _playOverride = !_playing);
    _scheduleAutoplay();
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 440;
      final inset = compact ? 12.0 : 26.0;
      return MouseRegion(
        onEnter: (_) {
          _hovered = true;
          _autoplay?.cancel();
        },
        onExit: (_) {
          _hovered = false;
          _scheduleAutoplay();
        },
        child: SizedBox(
          height: compact ? 290 : 370,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification)
                      _autoplay?.cancel();
                    if (notification is ScrollEndNotification)
                      _scheduleAutoplay();
                    return false;
                  },
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (index) => setState(() => _current = index),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            slide.photo,
                            fit: BoxFit.cover,
                            excludeFromSemantics: true,
                            errorBuilder: (_, _, _) =>
                                const ColoredBox(color: ColorsApp.graphite),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.30, 1],
                                colors: [Color(0x001C1F3A), Color(0xDC1C1F3A)],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(inset, 20, inset, 62),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  slide.city,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  slide.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: compact ? 20 : 28,
                                    height: 1.1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  top: compact ? 12 : 20,
                  left: compact ? 12 : 22,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorsApp.notebook,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        'Кампусы, в которых хочется учиться',
                        style: TextStyle(
                          color: ColorsApp.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: inset,
                  right: inset,
                  bottom: 10,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var index = 0; index < _slides.length; index++)
                              _thumbnail(index, compact: compact),
                            _control(
                              'Предыдущий слайд',
                              '←',
                              () => _goTo(_current - 1),
                            ),
                            _control(
                              'Следующий слайд',
                              '→',
                              () => _goTo(_current + 1),
                            ),
                            _control(
                              _playing
                                  ? 'Приостановить автопрокрутку'
                                  : 'Включить автопрокрутку',
                              _playing ? 'Ⅱ' : '▷',
                              _toggleAutoplay,
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
        ),
      );
    },
  );

  Widget _thumbnail(int index, {required bool compact}) {
    final slide = _slides[index];
    final active = index == _current;
    return Tooltip(
      message: slide.shortName,
      child: Semantics(
        selected: active,
        child: TextButton(
          onPressed: () => _goTo(index),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: compact ? 3 : 8),
            minimumSize: const Size(44, 44),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: compact ? 36 : 42,
                height: 28,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: active ? Colors.white : Colors.white38,
                    width: active ? 2 : 1,
                  ),
                ),
                child: Image.asset(
                  slide.preview,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 6),
                Text(slide.shortName),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _control(String label, String glyph, VoidCallback onPressed) =>
      IconButton(
        tooltip: label,
        color: Colors.white,
        onPressed: onPressed,
        icon: Text(
          glyph,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      );
}
