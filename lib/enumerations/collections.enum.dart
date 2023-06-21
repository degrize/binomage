enum Collections {
  binomage(name: "binomage-collection"),
  parrainFilleul(name: "parrainFilleul-collection"),
  parrainImageURls(name: "parrainImageURls-collection"),
  filleulImageURls(name: "filleulImageURls-collection");

  const Collections({
    required this.name,
  });
  final String name;
}
