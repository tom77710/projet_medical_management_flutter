class Personnel {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String emploi;
  final String? adresse;
  final String lastModified;

  Personnel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.emploi,
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
      'emploi': emploi,
      'adresse': adresse,
      'lastModified': lastModified,
    };
  }

  factory Personnel.fromMap(Map<String, dynamic> map) {
    return Personnel(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      telephone: map['telephone'],
      email: map['email'],
      emploi: map['emploi'],
      adresse: map['adresse'],
      lastModified: map['lastModified'],
    );
  }
}