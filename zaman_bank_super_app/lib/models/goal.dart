class Goal {
  final String id;
  final String userId;
  final String title;
  final double amountTarget;
  final double amountSaved;
  final DateTime deadlineDate;
  final double moneyAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    required this.amountTarget,
    required this.amountSaved,
    required this.deadlineDate,
    required this.moneyAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      amountTarget: (json['amountTarget'] ?? 0).toDouble(),
      amountSaved: (json['amountSaved'] ?? 0).toDouble(),
      deadlineDate: DateTime.parse(json['deadlineDate'] ?? DateTime.now().toIso8601String()),
      moneyAmount: (json['moneyAmount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amountTarget': amountTarget,
      'amountSaved': amountSaved,
      'deadlineDate': deadlineDate.toIso8601String(),
      'moneyAmount': moneyAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
