import 'package:flutter/material.dart';

class additionalInfoItem extends StatelessWidget {

  final String temperature;
  final IconData icon;
  final String tempData;

  const additionalInfoItem({
    super.key,
    required this.icon,
    required this.tempData,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(temperature, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
        const SizedBox(height: 8),
        Text(tempData, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),
      ],
    );
  }
}

