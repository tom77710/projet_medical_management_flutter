import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/patient.dart';
import '../database/db_helper.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      final db = DBHelper.instance;
      final exists = await db.isPhoneOrEmailTaken(
        _telephoneController.text,
        _emailController.text,
      );
      if (exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Téléphone ou e-mail déjà utilisé.')),
        );
        return;
      }
      final patient = Patient(
        id: const Uuid().v4(),
        nom: _nomController.text,
        prenom: _prenomController.text,
        telephone: _telephoneController.text,
        email: _emailController.text,
        adresse: _adresseController.text,
        lastModified: DateTime.now().toIso8601String(),
      );
      await db.insertPatient(patient);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient ajouté avec succès.')),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context, true);
    }
  }

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Ajouter un patient'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _prenomController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _telephoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Téléphone invalide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')
                      .hasMatch(value)) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adresseController,
                keyboardType: TextInputType.text,
                decoration:
                const InputDecoration(labelText: 'Adresse (optionnel)'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: _savePatient,
                    child: const Text('Enregistrer'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: ''),
        ],
      ),
    );
  }
}
