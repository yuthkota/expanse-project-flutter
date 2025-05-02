class CategoryStat {
  final String category;
  final double total;

  CategoryStat({
    required this.category,
    required this.total,
  });

  factory CategoryStat.fromJson(Map<String, dynamic> json) {
    return CategoryStat(
      category: json['CATEGORY'],
      total: double.parse(json['TOTAL'].toString()),
    );
  }
}
