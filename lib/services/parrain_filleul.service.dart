import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../enumerations/collections.enum.dart';
import '../models/parrain_filleul.dart';


Stream<List<ParrainFilleul>> getAllParrainFilleul() => FirebaseFirestore.instance
    .collection(Collections.parrainFilleul.name)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((e) => ParrainFilleul.fromJson(e.data())).toList());

Future createParrainFilleul(ParrainFilleul newDoc) async{
  final docCollection = FirebaseFirestore.instance
      .collection(Collections.parrainFilleul.name)
      .doc();

  final json = newDoc.toJson();
  await docCollection.set(json)
      .then((value) => {
    if (kDebugMode) {
      print("ParrainFilleul Added")
    }
  })
      .catchError((error) => {
    if (kDebugMode) {
      print("Failed to add ParrainFilleul: $error")
    }
  });
}

Future updateParrainFilleul(String docId, updateData) async {
  await FirebaseFirestore.instance
      .collection(Collections.parrainFilleul.name)
      .doc(docId)
      .update(updateData);
}

Future deleteParrainFilleul(String docId) async {
  await FirebaseFirestore.instance
      .collection(Collections.parrainFilleul.name)
      .doc(docId)
      .delete();
}

Future<ParrainFilleul> getParrainFilleulByDocId(String docId) async {
  final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance.collection(Collections.parrainFilleul.name)
      .doc(docId)
      .get();

  final ParrainFilleul parrainFilleul = ParrainFilleul.fromJson(snapshot.data()!);
  return parrainFilleul;
}
