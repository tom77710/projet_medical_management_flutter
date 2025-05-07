import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';
import '../database/db_helper.dart';

class FirebaseSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncPatientsToFirestore() async {
    final localPatients = await DBHelper.instance.getAllPatients();

    for (var patient in localPatients) {
      final docRef = _firestore.collection('patients').doc(patient.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set(patient.toMap());
      } else {
        final remoteLastModified = doc.data()?['lastModified'];
        if (remoteLastModified != null &&
            DateTime.parse(patient.lastModified).isAfter(DateTime.parse(remoteLastModified))) {
          await docRef.update(patient.toMap());
        }
      }
    }
  }

  Future<void> syncPatientsFromFirestore() async {
    final snapshot = await _firestore.collection('patients').get();
    final localPatients = await DBHelper.instance.getAllPatients();
    final localMap = {for (var p in localPatients) p.id: p};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final remotePatient = Patient.fromMap(data);
      final local = localMap[remotePatient.id];

      if (local == null) {
        // Nouveau depuis Firestore
        await DBHelper.instance.insertPatient(remotePatient);
      } else if (DateTime.parse(remotePatient.lastModified).isAfter(DateTime.parse(local.lastModified))) {
        // Mise à jour depuis Firestore
        await DBHelper.instance.updatePatient(remotePatient);
      }
    }
  }

  Future<void> fullSync() async {
    await syncPatientsToFirestore();
    await syncPatientsFromFirestore();
  }
}
