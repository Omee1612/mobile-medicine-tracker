import 'package:flutter/material.dart';
import 'package:timely_medicine/med_db.dart';

// ---- Design tokens ----
class _Palette {
  static const bg = Color(0xFFF6F5F1);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1F5F52); // deep forest teal
  static const primaryDark = Color(0xFF163F37);
  static const accent = Color(
    0xFFE0A945,
  ); // warm amber — reserved for time/alarm
  static const textDark = Color(0xFF22302C);
  static const textMuted = Color(0xFF6B7A75);
  static const border = Color(0xFFE1E4DE);
}

class medForm extends StatelessWidget {
  const medForm({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Timely Medicine';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _Palette.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _Palette.primary,
          primary: _Palette.primary,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            appTitle,
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
          ),
          backgroundColor: _Palette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class Medicine {
  final int? id;
  final String name;
  final int hour;
  final int minute;
  final String? dosage;
  Medicine({
    this.id,
    required this.name,
    this.dosage,
    required this.hour,
    required this.minute,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'hour': hour,
      'minute': minute,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      hour: map['hour'],
      minute: map['minute'],
    );
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String MedicineName = "";
  DateTime? time;
  int? Thour;
  int? Tmin;
  String Dosage = "";

  TimeOfDay? get medicineTime {
    if (Thour == null || Tmin == null) return null;
    return TimeOfDay(hour: Thour!, minute: Tmin!);
  }

  // Reusable section wrapper — a card with a label, icon, and consistent spacing
  Widget _sectionCard({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _Palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _Palette.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _Palette.textDark,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _Palette.textMuted),
      filled: true,
      fillColor: _Palette.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _Palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _Palette.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }

  // The "clock face" signature element — big bold digits styled like a digital alarm clock
  Widget _timeDigitBox({
    required String hint,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Container(
      width: 76,
      height: 72,
      decoration: BoxDecoration(
        color: _Palette.primaryDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 2,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          errorStyle: const TextStyle(height: 0.6, fontSize: 10),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              MedicineName.isEmpty ? "New reminder" : MedicineName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _Palette.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Fill in the details below and we'll remind you on time.",
              style: TextStyle(color: _Palette.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 22),

            _sectionCard(
              icon: Icons.medication_outlined,
              label: "MEDICINE NAME",
              child: TextFormField(
                decoration: _fieldDecoration("e.g. Amoxicillin"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medicine name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  MedicineName = value;
                }),
              ),
            ),

            _sectionCard(
              icon: Icons.science_outlined,
              label: "DOSAGE (OPTIONAL)",
              child: TextFormField(
                decoration: _fieldDecoration("e.g. 500mg, 2 tablets"),
                validator: (value) => null,
                onChanged: (value) => setState(() {
                  Dosage = value;
                }), // truly optional — fixed from before
              ),
            ),

            _sectionCard(
              icon: Icons.alarm,
              label: "REMINDER TIME",
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _timeDigitBox(
                      hint: "HH",
                      onChanged: (value) => setState(() {
                        Thour = int.tryParse(value);
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) return '';
                        final hour = int.tryParse(value);
                        if (hour == null || hour < 0 || hour > 23) return '';
                        return null;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: _Palette.accent,
                        ),
                      ),
                    ),
                    _timeDigitBox(
                      hint: "MM",
                      onChanged: (value) => setState(() {
                        Tmin = int.tryParse(value);
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) return '';
                        final min = int.tryParse(value);
                        if (min == null || min < 0 || min > 59) return '';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Palette.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  final formValid = _formKey.currentState!.validate();
                  final finalTime = medicineTime;

                  if (!formValid || finalTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields correctly'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final medicine = Medicine(
                    name: MedicineName,
                    dosage: Dosage.isEmpty ? null : Dosage,
                    hour: finalTime.hour,
                    minute: finalTime.minute,
                  );

                  await MedicineDB.instance.insertMedicine(medicine);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$MedicineName saved for ${finalTime.hour.toString().padLeft(2, '0')}:${finalTime.minute.toString().padLeft(2, '0')}',
                      ),
                      backgroundColor: _Palette.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text(
                  "Save reminder",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
