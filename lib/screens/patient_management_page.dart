import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/patient.dart';
import '../database/db_helper.dart';
import '../services/firebase_sync_service.dart';
import 'add_patient_page.dart';
import 'edit_patient_page.dart';

class PatientManagementPage extends StatefulWidget {
  const PatientManagementPage({super.key});

  @override
  State<PatientManagementPage> createState() => _PatientManagementPageState();
}

class _PatientManagementPageState extends State<PatientManagementPage> {
  List<Patient> _patients = [];
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        _syncAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion détectée : synchronisation Firebase lancée')),
        );
      }
    });
  }

  Future<void> _loadPatients() async {
    final patients = await DBHelper.instance.getAllPatients();
    setState(() {
      _patients = patients;
    });
  }

  Future<void> _syncAll() async {
    await FirebaseSyncService().fullSync();
    await _loadPatients();
  }

  Future<void> _deletePatient(String id) async {
    await DBHelper.instance.deletePatient(id);
    _loadPatients();
  }

  Future<void> _navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPatientPage()),
    );
    if (result == true) _loadPatients();
  }

  Future<void> _navigateToEditPage(Patient patient) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPatientPage(patient: patient)),
    );
    if (result == true) _loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Synchroniser Firebase',
            onPressed: _syncAll,
          ),
        ],
      ),
      body: _patients.isEmpty
          ? const Center(child: Text('Aucun patient enregistré.'))
          : ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return ListTile(
            title: Text('${patient.nom} ${patient.prenom}'),
            subtitle: Text(patient.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEditPage(patient),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deletePatient(patient.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        tooltip: 'Ajouter un patient',
        child: const Icon(Icons.add),
      ),
    );
  }
}
