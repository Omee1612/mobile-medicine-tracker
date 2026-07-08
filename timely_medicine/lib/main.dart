import 'package:flutter/material.dart';
import 'package:timely_medicine/display_med.dart';
import 'home_card.dart';
import 'addMed.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Timely Medicine',
      home: SafeArea(child: TimelyMedicine()),
    ),
  );
}

class TimelyMedicine extends StatelessWidget {
  const TimelyMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green[700],
          title: const Text(
            "Timely Medicine",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: const TimelyBody(),
      ),
    );
  }
}

class TimelyBody extends StatelessWidget {
  const TimelyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddMedicinePage()),
              );
            },
            child: HomeCard(
              label: "Add Medicine",
              icon: Icons.add_circle_outline,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => DisplayMed()));
            },
            child: HomeCard(
              label: "See Added Medicines",
              icon: Icons.add_circle_outline,
            ),
          ),
          SizedBox(height: 20),
          HomeCard(label: "Options", icon: Icons.settings_outlined),
        ],
      ),
    );
  }
}
