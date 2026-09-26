import 'package:flutter/material.dart';

import '../../models/location_search_model.dart';

class LocationSearchResults extends StatelessWidget {
  final List<LocationSearchModel> locations;
  final ValueChanged<LocationSearchModel> onLocationSelected;

  const LocationSearchResults({
    super.key,
    required this.locations,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: locations.map((location) {
          return Material(
            child: ListTile(
              leading: const Icon(
                Icons.location_on,
              ),
              title: Text(
                location.name,
              ),
              subtitle: Text(
                [
                  if (location.state != null)
                    location.state!,
                  location.country,
                ].join(', '),
              ),
              onTap: () {
                onLocationSelected(location);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}