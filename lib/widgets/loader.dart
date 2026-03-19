import 'dart:math';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  final String text;
  final double logoSize;
  final Color? backgroundColor;

  const Loader({
    super.key,
    this.text = 'Loading',
    this.logoSize = 96.0,
    this.backgroundColor,
  });

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = widget.backgroundColor ?? Colors.transparent;
    return Material(
      color: bg,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Decide whether there's enough vertical space to show the
            // spacer + animated text. If the available height is tight (for
            // example when Loader is used inside a 22x22 icon slot), only
            // render the rotating logo to avoid overflow.
            final maxH = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : double.infinity;
            // Rough estimate for text+spacing height
            const extraHeight = 18.0 + 18.0; // spacer + text approx
            final showText =
                maxH == double.infinity ||
                maxH >= (widget.logoSize + extraHeight);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: widget.logoSize,
                  height: widget.logoSize,
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (context, child) {
                      final t = _ctrl.value;
                      final rotation =
                          lerpDouble(-0.08, 0.08, (sin(2 * pi * t) + 1) / 2) ??
                          0;
                      final scale = 0.92 + 0.08 * (0.5 + 0.5 * sin(2 * pi * t));

                      return Transform.rotate(
                        angle: rotation,
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: const Image(
                      image: AssetImage('assets/logo/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                if (showText) const SizedBox(height: 18),

                if (showText)
                  _AnimatedLoadingText(
                    text: widget.text,
                    color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                    controller: _ctrl,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedLoadingText extends AnimatedWidget {
  final String text;
  final Color color;

  const _AnimatedLoadingText({
    required Animation<double> controller,
    required this.text,
    required this.color,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final anim = listenable as Animation<double>;
    final phase = (anim.value * 3).floor() % 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        // If there's not enough horizontal or vertical space, don't render the
        // animated text/dots to avoid RenderFlex overflow in tight containers.
        if (constraints.maxWidth < 40 || constraints.maxHeight < 18) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            for (var i = 0; i < 3; i++)
              Opacity(
                opacity: (i <= phase) ? 1.0 : 0.25,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  final aa = a?.toDouble() ?? 0.0;
  final bb = b?.toDouble() ?? 0.0;
  return aa + (bb - aa) * t;
}