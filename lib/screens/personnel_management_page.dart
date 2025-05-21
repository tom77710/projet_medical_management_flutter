import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/personnel.dart';
import 'add_personnel_page.dart';
import 'edit_personnel_page.dart';

class PersonnelManagementPage extends StatefulWidget {
  const PersonnelManagementPage({Key? key}) : super(key: key);

  @override
  _PersonnelManagementPageState createState() => _PersonnelManagementPageState();
}

class _PersonnelManagementPageState extends State<PersonnelManagementPage> {
  late Future<List<Personnel>> _personnelList;

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  void _loadPersonnel() {
    setState(() {
      _personnelList = DBHelper.instance.getPersonnel();
    });
  }

  void _navigateToAddPersonnel() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPersonnelPage()),
    );
    _loadPersonnel();
  }

  void _navigateToEditPersonnel(Personnel personnel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPersonnelPage(personnel: personnel)),
    );
    _loadPersonnel();
  }

  void _confirmDeletePersonnel(Personnel personnel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Supprimer ${personnel.nom} ${personnel.prenom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await DBHelper.instance.deletePersonnel(personnel.id);
              if (!mounted) return;
              Navigator.of(ctx).pop();
              _loadPersonnel();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion du Personnel')),
      body: FutureBuilder<List<Personnel>>(
        future: _personnelList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun personnel trouvé.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final personnel = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('${personnel.nom} ${personnel.prenom}'),
                    subtitle: Text('${personnel.emploi} | ${personnel.email} | ${personnel.telephone}'),
                    onTap: () => _navigateToEditPersonnel(personnel),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeletePersonnel(personnel),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPersonnel,
        child: const Icon(Icons.add),
      ),
    );
  }
}