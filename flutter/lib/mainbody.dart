import 'package:flutter/material.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  Map<int, CheckboxItem> checkboxData = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(checkboxData.length, (index) {
              return Card(
                child: Row(
                  children: [
                    Checkbox(
                      value: checkboxData[index]?.isChecked ?? false,
                      onChanged: (value) {
                        setState(() {
                          if (checkboxData[index] != null) {
                            checkboxData[index]!.isChecked = value ?? false;
                          }
                        });
                      },
                    ),
                    Text(checkboxData[index]?.label ?? ''),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CheckboxItem {
  bool isChecked;
  String label;

  CheckboxItem({required this.isChecked, required this.label});
}