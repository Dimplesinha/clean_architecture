import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories = [
    Category(icon: Icons.grid_view, label: 'All'),
    Category(icon: Icons.work_outline, label: 'Services'),
    Category(icon: Icons.hotel, label: 'Hotels'),
    Category(icon: Icons.apartment, label: 'Real Estate'),
    Category(icon: Icons.car_rental, label: 'Vehicles'),
    Category(icon: Icons.group, label: 'Community'),
    Category(icon: Icons.calendar_today, label: 'Events'),
  ];

   CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 30),  // Adjust icon size as needed
                Text(category.label, style: const TextStyle(fontSize: 12)),  // Adjust font size as needed
              ],
            ),
          );
        },
      ),
    );
  }
}

class Category {
  final IconData icon;
  final String label;

  Category({required this.icon, required this.label});
}