import 'package:application_des_activites_mai/model/activite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActiviteDao{
    final CollectionReference activiteCollection =
      FirebaseFirestore.instance.collection('activite');

  Future<void> insertActivite(Activite activite) async {
    await activiteCollection.add(activite.toJson());
  }
}