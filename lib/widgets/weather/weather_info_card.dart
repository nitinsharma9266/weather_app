import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class WeatherInfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;

  const WeatherInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  State<WeatherInfoCard> createState() =>
      _WeatherInfoCardState();
}

class _WeatherInfoCardState extends State<WeatherInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(
      covariant WeatherInfoCard oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF101D2A)
        : Colors.white;

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    final Color iconColor =
    isDark
        ? const Color(0xFF55B9FF)
        : AppColors.primary;

    return Expanded(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 132,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(
                  alpha: 0.07,
                )
                    : Colors.black.withValues(
                  alpha: 0.04,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.25 : 0.07,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  // ==========================================
                  // ICON
                  // ==========================================

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(
                        alpha: isDark
                            ? 0.14
                            : 0.09,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: iconColor,
                      size: 23,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // ==========================================
                  // VALUE
                  // ==========================================

                  Text(
                    widget.value,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ==========================================
                  // TITLE
                  // ==========================================

                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w500,
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