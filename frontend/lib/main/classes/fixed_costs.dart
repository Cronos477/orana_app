class FixedCosts {
  String? id;
  String name;
  String description;
  int value;

  FixedCosts({
    this.id,
    required this.name,
    this.description = "",
    this.value = 0
  });
}