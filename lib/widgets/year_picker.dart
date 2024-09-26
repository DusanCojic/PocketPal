import 'package:flutter/material.dart';

class YearPicker extends StatefulWidget {
  final Function(int) onSelectedYear;

  const YearPicker({
    super.key,
    required this.onSelectedYear,
  });

  @override
  State<StatefulWidget> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  late List<int> years;
  late int selectedYear;

  @override
  void initState() {
    int currentYear = DateTime.now().year;
    selectedYear = currentYear;
    years =
        List.generate(currentYear - 2000 + 1, (index) => currentYear - index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400.0,
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
              "Pick a year",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: years.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    years[index].toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    setState(() {
                      selectedYear = years[index];
                    });

                    widget.onSelectedYear(selectedYear);

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
