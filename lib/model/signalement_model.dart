class SignalementModel {
  final String nom;
  final String prenom;
  final String statutUser;
  final String commentaire;
  final double latitude;
  final double longitude;
  final bool isAnonyme;
  final String statutSignalement;
  final DateTime createdAt;

  SignalementModel({
    required this.nom,
    required this.prenom,
    required this.statutUser,
    required this.commentaire,
    required this.latitude,
    required this.longitude,
    required this.isAnonyme,
    required this.statutSignalement,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'statutUser': statutUser,
      'commentaire': commentaire,
      'latitude': latitude,
      'longitude': longitude,
      'isAnonyme': isAnonyme,
      'statutSignalement': statutSignalement,
      'createdAt': createdAt,
    };
  }

  factory SignalementModel.fromMap(Map<String, dynamic> map) {
    return SignalementModel(
      nom: map['nom'],
      prenom: map['prenom'],
      statutUser: map['statutUser'],
      commentaire: map['commentaire'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isAnonyme: map['isAnonyme'],
      statutSignalement: map['statutSignalement'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}
