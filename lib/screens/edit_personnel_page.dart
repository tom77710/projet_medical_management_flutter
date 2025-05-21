import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/personnel.dart';

class EditPersonnelPage extends StatefulWidget {
  final Personnel personnel;

  const EditPersonnelPage({Key? key, required this.personnel}) : super(key: key);

  @override
  _EditPersonnelPageState createState() => _EditPersonnelPageState();
}

class _EditPersonnelPageState extends State<EditPersonnelPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late String _emploi;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.personnel.nom);
    _prenomController = TextEditingController(text: widget.personnel.prenom);
    _emailController = TextEditingController(text: widget.personnel.email);
    _telephoneController = TextEditingController(text: widget.personnel.telephone);
    _emploi = widget.personnel.emploi;
  }

  Future<void> _updatePersonnel() async {
    if (_formKey.currentState!.validate()) {
      final updatedPersonnel = Personnel(
        id: widget.personnel.id,
        nom: _nomController.text,
        prenom: _prenomController.text,
        emploi: _emploi,
        email: _emailController.text,
        telephone: _telephoneController.text,
        adresse: widget.personnel.adresse,
        lastModified: DateTime.now().toIso8601String(),
      );
      await DBHelper.instance.updatePersonnel(updatedPersonnel);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le Personnel')),
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
                onPressed: _updatePersonnel,
                child: const Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}