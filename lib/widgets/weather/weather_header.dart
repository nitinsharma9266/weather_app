import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/weather_model.dart';

class WeatherHeader extends StatefulWidget {
  final WeatherModel? weather;

  const WeatherHeader({
    super.key,
    required this.weather,
  });

  @override
  State<WeatherHeader> createState() => _WeatherHeaderState();
}

class _WeatherHeaderState extends State<WeatherHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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
  void didUpdateWidget(covariant WeatherHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.weather != widget.weather) {
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
        Theme.of(context).brightness == Brightness.dark;

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    final Color cardStartColor = isDark
        ? const Color(0xFF12345A)
        : const Color(0xFFBFE4FF);

    final Color cardEndColor = isDark
        ? const Color(0xFF0B1726)
        : const Color(0xFFEAF6FF);

    final String iconCode =
        widget.weather?.icon ?? '01d';

    final String iconUrl =
        'https://openweathermap.org/img/wn/'
        '${iconCode}@4x.png';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            22,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardStartColor,
                cardEndColor,
              ],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.30 : 0.08,
                ),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            children: [
              // ==================================================
              // WEATHER ICON
              // ==================================================

              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(
                    alpha: isDark ? 0.07 : 0.45,
                  ),
                ),
                child: Image.network(
                  iconUrl,
                  width: 95,
                  height: 95,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Icon(
                      Icons.wb_sunny_rounded,
                      size: 58,
                      color: AppColors.weatherAccent,
                    );
                  },
                ),
              ),

              const SizedBox(height: 4),

              // ==================================================
              // TEMPERATURE
              // ==================================================

              Text(
                widget.weather == null
                    ? '--°C'
                    : '${widget.weather!.temperature.round()}°C',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 52,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                ),
              ),

              const SizedBox(height: 5),

              // ==================================================
              // CONDITION
              // ==================================================

              Text(
                widget.weather?.condition ?? '--',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // FEELS LIKE
              // ==================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: isDark ? 0.08 : 0.50,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  widget.weather == null
                      ? 'Feels like --°C'
                      : 'Feels like '
                      '${widget.weather!.feelsLike.round()}°C',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}