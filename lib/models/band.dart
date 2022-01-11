class Band {
  String id;
  String? name;
  int? votes;

  Band({
    required this.id,
    this.name = 'Default Name',
    this.votes = 0,
  });

  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj['id'], name: obj['name'], votes: obj['votes']);
}
