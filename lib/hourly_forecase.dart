import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {

  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForecast({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 32,),
            const SizedBox(height: 8),
            Text(
              temperature,
            )
          ],
        ),
      ),
    );
  }
}
