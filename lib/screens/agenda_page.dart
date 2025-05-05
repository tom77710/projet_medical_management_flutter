import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Agenda'),
      body: const Center(
        child: Text('Agenda - Calendrier et événements'),
      ),
    );
  }
}