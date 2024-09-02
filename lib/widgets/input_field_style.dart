import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String label,
  required bool emptyCheck,
  required IconData? icon,
}) {
  return InputDecoration(
    fillColor: Colors.white,
    errorText: emptyCheck ? "This field cannot be empty" : null,
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 3,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blueAccent,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blueAccent,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    labelText: label,
    prefixIcon: icon == null ? null : Icon(icon),
    contentPadding: const EdgeInsets.only(left: 20),
  );
}
