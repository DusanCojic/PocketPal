import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PeriodPicker extends StatefulWidget {
  final Function(String) onSelected;

  const PeriodPicker({super.key, required this.onSelected});

  @override
  State<StatefulWidget> createState() => _PeriodPickerState();
}

class _PeriodPickerState extends State<PeriodPicker> {
  final List<String> periods = [
    "This month",
    "Today",
    "This week",
    "This year",
    "All",
  ];

  late String chosen = periods[0];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 35,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Text(
              "Pick a period",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: periods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    periods[index],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    setState(() {
                      chosen = periods[index];
                    });

                    widget.onSelected(chosen);

                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
