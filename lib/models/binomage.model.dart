import 'package:binomage/models/parrain_filleul.dart';

class Binomage {
  String id;
  String titre;
  List<ParrainFilleul>? parrainFilleuls;

  Binomage({
    this.id = "",
    required this.titre,
    this.parrainFilleuls,
  });

  static Binomage fromJson(Map<String, dynamic> json) => Binomage(
    id: json["id"],
    titre: json["titre"],
    parrainFilleuls: json["parrainFilleuls"] == null ? [] : List<ParrainFilleul>.from(json["parrainFilleuls"].map((x) => ParrainFilleul.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titre": titre,
    "parrainFilleuls": parrainFilleuls == null ? [] : List<dynamic>.from(parrainFilleuls!.map((x) => x.toJson())),
  };
}