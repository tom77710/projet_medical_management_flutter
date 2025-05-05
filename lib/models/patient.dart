class Patient {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String? adresse;
  final String lastModified;

  Patient({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    this.adresse,
    required this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
      'lastModified': lastModified,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      telephone: map['telephone'],
      email: map['email'],
      adresse: map['adresse'],
      lastModified: map['lastModified'],
    );
  }
}
