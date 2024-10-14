class Record {
  final int id;
  final String type;
  final double amount;
  final String category;
  final int categoryId;
  final String? description;
  final DateTime recordDate;

  Record({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.categoryId,
    this.description,
    required this.recordDate,
  });

  factory Record.fromJson(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      category: map['category_name'],
      categoryId: map['category_id'],
      description: map['description'],
      recordDate: DateTime.parse(map['record_date']),
    );
  }
}
