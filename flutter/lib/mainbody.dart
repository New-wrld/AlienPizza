import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'page2.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  Map<int, CheckboxItem> checkboxData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchToppings();
  }

  Future<void> fetchToppings() async {
    try {
      final response = await http.get(Uri.parse(
          'https://alien-pizza-28ebb921ad43.herokuapp.com/api/toppings'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<String> toppings = List<String>.from(data['toppings']);

        setState(() {
          checkboxData = {
            for (int i = 0; i < toppings.length; i++)
              i: CheckboxItem(isChecked: false, label: toppings[i])
          };
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToScreen2() async {
    final selectedToppings = checkboxData.values
        .where((item) => item.isChecked)
        .map((item) => item.label)
        .toList();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: const Text('Alien Pizza Evaluation'),
              ),
              body: Screen2(selectedToppings: selectedToppings),
            ),
      ),
    );

    await fetchToppings();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select your pizza toppings!',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2,
              padding: const EdgeInsets.all(8.0),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: List.generate(checkboxData.length, (index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (checkboxData[index] != null) {
                          checkboxData[index]!.isChecked =
                          !checkboxData[index]!.isChecked;
                        }
                      });
                    },
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
                        Expanded(
                          child: Text(checkboxData[index]?.label ?? ''),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: fetchToppings,
            child: const Icon(Icons.refresh),
          ),
          if (checkboxData.values.any((item) => item.isChecked)) ...[
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: 'forward',
              onPressed: _navigateToScreen2,
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ],
      ),
    );
  }
}

class CheckboxItem {
  bool isChecked;
  String label;

  CheckboxItem({required this.isChecked, required this.label});
}
