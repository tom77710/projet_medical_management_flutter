import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class PersonnelManagementPage extends StatelessWidget {
  const PersonnelManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestion personnels'),
      body: const Center(
        child: Text('Liste du personnel'),
      ),
    );
  }
}