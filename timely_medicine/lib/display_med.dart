import 'package:flutter/material.dart';
import 'package:timely_medicine/med_db.dart';
import 'package:timely_medicine/addMedForm.dart';

class DisplayMed extends StatelessWidget {
  DisplayMed({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Display Your Medicine Schedule",
      home: Scaffold(
        appBar: AppBar(title: Text("Medicines will be shown here")),
        body: const DisplayMedSt(),
      ),
    );
  }
}

class DisplayMedSt extends StatefulWidget {
  const DisplayMedSt({super.key});
  @override
  State<DisplayMedSt> createState() => _useDisplayMedSt();
}

class _useDisplayMedSt extends State<DisplayMedSt> {
  late Future<List<Medicine>> medicinesFuture;

  void initState() {
    super.initState();
    medicinesFuture = MedicineDB.instance.getAllMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Medicine>>(
      future: medicinesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading..."));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final medicines = snapshot.data ?? [];
        if (medicines.isEmpty) {
          return const Center(child: Text("No medicines exist"));
        }
        return ListView.builder(
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            final hour = medicine.hour.toString().padLeft(2, '0');
            final minute = medicine.minute.toString().padLeft(2, '0');
            return ListTile(
              leading: const Icon(Icons.medication_outlined),
              title: Text(medicine.name),
              subtitle: Text(
                medicine.dosage == null || medicine.dosage!.isEmpty
                    ? '$hour:$minute'
                    : '${medicine.dosage} ; $hour:$minute',
              ),
            );
          },
        );
      },
    );
  }
}
