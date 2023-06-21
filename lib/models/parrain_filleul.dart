class ParrainFilleul {
  String id;
  String nomComplet;

  ParrainFilleul({
    this.id = "",
    this.nomComplet = "sans nom",
  });

  static ParrainFilleul fromJson(Map<String, dynamic> json) => ParrainFilleul(
    id: json["id"],
    nomComplet: json["nom_complet"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom_complet": nomComplet,
  };
}