class Task {
  final int indicatorToMoId;
  final String name;
   int parentId;
  int order;

  Task({
    required this.indicatorToMoId,
    required this.name,
    required this.parentId,
    required this.order,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      indicatorToMoId: json['indicator_to_mo_id'] is int
          ? json['indicator_to_mo_id']
          : int.parse(json['indicator_to_mo_id'].toString()),
      name: json['name'] ?? 'Sans nom',
      parentId: json['parent_id'] is int
          ? json['parent_id']
          : int.parse(json['parent_id'].toString()),
      order: json['order'] is int
          ? json['order']
          : int.parse(json['order'].toString()),
    );
  }
}