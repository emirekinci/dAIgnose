import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String hospitalName;
  final String availableDaysText;
  final bool isAvailable;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctorName,
    required this.hospitalName,
    required this.availableDaysText,
    required this.isAvailable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isAvailable ? Colors.red : Colors.redAccent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(
          doctorName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(hospitalName, style: TextStyle(color: Colors.white54)),
        trailing: Text(
          availableDaysText,
          style: TextStyle(color: Colors.white),
        ),
        onTap: onTap,
      ),
    );
  }
}
