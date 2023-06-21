import 'package:cloud_firestore/cloud_firestore.dart';

import '../enumerations/collections.enum.dart';
import '../models/binomage.model.dart';


Stream<List<Binomage>> getAllBinomage() => FirebaseFirestore.instance
    .collection(Collections.binomage.name)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((e) => Binomage.fromJson(e.data())).toList());


Future createBinomage(Binomage newDoc) async{
  final docCollection = FirebaseFirestore.instance
      .collection(Collections.binomage.name)
      .doc();
  // final newDoc = Binomage(nom: "nom", prenom: "prenom", contact: "contact",
  //     lieuHabitation: "lieuHabitation", zoneOperation: "zoneOperation",
  //     photo: "photo", photoCamera: "photoCamera", imgCniRecto: "imgCniRecto",
  //     imgCniVerso: "imgCniVerso", dateAjout: "dateAjout", dateModif: "dateModif");

  final json = newDoc.toJson();
  await docCollection.set(json);
}

Future updateBinomage(String docId, updateData) async {
  // docId = '0v80YXnvALocq8jGUEbo';
  //updateData = {'contact': '0988123456'};
  await FirebaseFirestore.instance
      .collection(Collections.binomage.name)
      .doc(docId)
      .update(updateData);
}

Future deleteBinomage(String docId) async {
  // docId = '0v80YXnvALocq8jGUEbo';
  await FirebaseFirestore.instance
      .collection(Collections.binomage.name)
      .doc(docId)
      .delete();
}

Future<Binomage> getBinomageByDocId(String docId) async {
  final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance.collection(Collections.binomage.name)
      .doc(docId)
      .get();

  final Binomage binomage = Binomage.fromJson(snapshot.data()!);
  return binomage;
}

Future<List<Binomage>> getBinomages() async {
  print("binomages");
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(Collections.binomage.name).get();
  List<Binomage> binomages = [];
  snapshot.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Binomage binomage = Binomage.fromJson(data);
    binomages.add(binomage);
  });

  return binomages;
}
