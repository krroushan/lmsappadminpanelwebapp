class Board {
  final String id;
  final String name;
  final String description;
  final String boardImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Board({
    required this.id,
    required this.name,
    required this.description,
    required this.boardImage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Board from JSON
  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      boardImage: json['boardImage'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'boardImage': boardImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}