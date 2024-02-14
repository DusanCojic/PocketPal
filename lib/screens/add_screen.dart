import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: MediaQuery.of(context).size.width,
      child: const Center(
        child: Text('Add screen'),
      ),
    );
  }
}
