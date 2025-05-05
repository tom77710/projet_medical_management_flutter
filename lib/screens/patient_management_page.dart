import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class PatientManagementPage extends StatelessWidget {
  const PatientManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestion patient'),
      body: const Center(
        child: Text('Liste des patients'),
      ),
    );
  }
}