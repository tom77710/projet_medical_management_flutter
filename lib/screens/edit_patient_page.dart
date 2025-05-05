import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../database/db_helper.dart';

class EditPatientPage extends StatefulWidget {
  final Patient patient;

  const EditPatientPage({super.key, required this.patient});

  @override
  State<EditPatientPage> createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telephoneController;
  late TextEditingController _emailController;
  late TextEditingController _adresseController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.patient.nom);
    _prenomController = TextEditingController(text: widget.patient.prenom);
    _telephoneController = TextEditingController(text: widget.patient.telephone);
    _emailController = TextEditingController(text: widget.patient.email);
    _adresseController = TextEditingController(text: widget.patient.adresse ?? '');
  }

  Future<void> _updatePatient() async {
    if (_formKey.currentState!.validate()) {
      final updatedPatient = Patient(
        id: widget.patient.id,
        nom: _nomController.text,
        prenom: _prenomController.text,
        telephone: _telephoneController.text,
        email: _emailController.text,
        adresse: _adresseController.text,
        lastModified: DateTime.now().toIso8601String(),
      );

      await DBHelper.instance.updatePatient(updatedPatient);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePatient,
                child: const Text('Mettre à jour'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
