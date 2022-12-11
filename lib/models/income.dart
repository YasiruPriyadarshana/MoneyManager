class Income {
  String category;
  double amount;
  String date;

  Income({required this.category, required this.amount, required this.date});

  Map<String, dynamic> toMap() {
    return {'category': category, 'amount': amount, 'date': date};
  }
}
