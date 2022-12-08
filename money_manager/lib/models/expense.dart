class Expense {
  String category;
  double amount;
  String unit;
  String icon;
  String date;

  Expense(
      {required this.category,
      required this.amount,
      required this.unit,
      required this.icon,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'unit': unit,
      'icon': icon,
      'date': date
    };
  }
}
