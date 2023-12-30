import 'package:cloud_firestore/cloud_firestore.dart';

class Activite {
  String id;
  String titre;
  String lieu;
  String categorie;
  double prix;
  String image;
  int nbrPersonMin;

  Activite({
    required this.id,
    required this.titre,
    required this.lieu,
    required this.categorie,
    required this.prix,
    required this.image,
    required this.nbrPersonMin,
  });

  factory Activite.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Activite(
      id: doc.id,
      lieu: data['lieu'] ?? '',
      titre: data['titre'] ?? '',
      categorie: data['categorie'] ?? '',
      prix: (data['prix'] ?? 0.0).toDouble(),
      image: data['image'] ?? '',
      nbrPersonMin: data['nbrPersonMin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lieu': lieu,
      'titre': titre,
      'categorie': categorie,
      'prix': prix,
      'image': image,
      'nbrPersonMin':nbrPersonMin,
    };
  }
}