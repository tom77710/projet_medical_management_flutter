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
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un patient')),
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
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(labelText: 'Adresse (optionnel)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePatient,
                child: const Text('Enregistrer'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
