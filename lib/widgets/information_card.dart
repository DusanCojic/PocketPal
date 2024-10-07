import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final String info;
  final Color color;
  final double width;
  final double height;

  const InformationCard({
    super.key,
    required this.title,
    required this.info,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 7.0),
              child: Text(
                info,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
