import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Prise de rendez-vous'),
      body: const Center(
        child: Text('Champs patient / date / praticien'),
      ),
    );
  }
}