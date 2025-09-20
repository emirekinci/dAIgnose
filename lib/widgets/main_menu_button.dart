import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  const MainMenuButton({
    super.key,
    required this.themeColor,
    this.boxColor = Colors.white,
    required this.onTap,
    required this.text,
    required this.textColor,
    required this.icon,
    required this.iconColor,
  });

  final Color themeColor;
  final Color boxColor;
  final VoidCallback? onTap;
  final String text;
  final Color textColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 7.0,
      color: boxColor,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 90,
        height: 50.0,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextButton(
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 5.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
