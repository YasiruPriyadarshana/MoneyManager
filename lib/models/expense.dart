class Expense {
  String category;
  double amount;
  int icon;
  String date;

  Expense(
      {required this.category,
      required this.amount,
      required this.icon,
      required this.date});

  Map<String, dynamic> toMap() {
    return {'category': category, 'amount': amount, 'icon': icon, 'date': date};
  }
}
