import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/text_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Icon(icon, size: 80, color: Colors.black12,),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString(),
                  style: AppTextStyles.statCardHeading,
                ),
                const SizedBox(height: 4),
                Text(title, style: AppTextStyles.statBody),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
