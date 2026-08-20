class Expense {
  final int? id;
  final double amount;
  final String merchantName;
  final int timestamp;
  final String bankOrTelecom;
  final bool isIncome;
  final String category;

  Expense({
    this.id,
    required this.amount,
    required this.merchantName,
    required this.timestamp,
    required this.bankOrTelecom,
    required this.isIncome,
    this.category = 'Uncategorized',
  });

  // Convert an Expense into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'merchant_name': merchantName,
      'timestamp': timestamp,
      'bank_or_telecom': bankOrTelecom,
      'is_income': isIncome ? 1 : 0,
      'category': category,
    };
  }

  // A method that extracts an Expense object from a Map.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      amount: map['amount'] as double,
      merchantName: map['merchant_name'] as String,
      timestamp: map['timestamp'] as int,
      bankOrTelecom: map['bank_or_telecom'] as String,
      isIncome: (map['is_income'] as int) == 1,
      category: map['category'] as String,
    );
  }

  Expense copyWith({
    int? id,
    double? amount,
    String? merchantName,
    int? timestamp,
    String? bankOrTelecom,
    bool? isIncome,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      merchantName: merchantName ?? this.merchantName,
      timestamp: timestamp ?? this.timestamp,
      bankOrTelecom: bankOrTelecom ?? this.bankOrTelecom,
      isIncome: isIncome ?? this.isIncome,
      category: category ?? this.category,
    );
  }
}