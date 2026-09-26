import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class WeatherSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        const Icon(
          Icons.search,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SearchBar(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            hintText: "Search for city",
            elevation: WidgetStateProperty.all(2),
            backgroundColor:
            WidgetStateProperty.all(AppColors.white),
          ),
        ),
      ],
    );
  }
}