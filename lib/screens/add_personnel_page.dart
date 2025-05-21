import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/personnel.dart';

class AddPersonnelPage extends StatefulWidget {
  const AddPersonnelPage({Key? key}) : super(key: key);

  @override
  _AddPersonnelPageState createState() => _AddPersonnelPageState();
}

class _AddPersonnelPageState extends State<AddPersonnelPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  String _emploi = 'médecin';

  Future<void> _savePersonnel() async {
    if (_formKey.currentState!.validate()) {
      final personnel = Personnel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nom: _nomController.text,
        prenom: _prenomController.text,
        emploi: _emploi,
        email: _emailController.text,
        telephone: _telephoneController.text,
        lastModified: DateTime.now().toIso8601String(),
      );
      await DBHelper.instance.insertPersonnel(personnel);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Personnel')),
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
              DropdownButtonFormField<String>(
                value: _emploi,
                items: ['médecin', 'chirurgien', 'secrétaire', 'assistant', 'stagiaire']
                    .map((poste) => DropdownMenuItem(value: poste, child: Text(poste)))
                    .toList(),
                onChanged: (value) => setState(() => _emploi = value!),
                decoration: const InputDecoration(labelText: 'Poste'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePersonnel,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}