class WalletTransactionsResponse {
  bool? error;
  String? message;
  List<WalletTransaction>? transactions;

  WalletTransactionsResponse({
    this.error,
    this.message,
    this.transactions,
  });

  factory WalletTransactionsResponse.fromJson(Map<String, dynamic> json) => WalletTransactionsResponse(
    error: json["error"],
    message: json["message"],
    transactions: json["transactions"] == null
        ? []
        : List<WalletTransaction>.from(json["transactions"]!.map((x) => WalletTransaction.fromJson(x))),
  );
}

class WalletTransaction {
  final int id;
  final String type;
  final double amount;
  final String description;
  final String date;
  final double balanceAfter;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.balanceAfter,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
    id: json['id'] ?? 0,
    type: json['type'] ?? 'debit',
    amount: (json['amount'] ?? 0).toDouble(),
    description: json['description'] ?? '',
    date: json['date'] ?? '',
    balanceAfter: (json['balance_after'] ?? 0).toDouble(),
  );
}

class WalletSummaryResponse {
  bool? error;
  String? message;
  WalletSummary? walletSummary;

  WalletSummaryResponse({
    this.error,
    this.message,
    this.walletSummary,
  });

  factory WalletSummaryResponse.fromJson(Map<String, dynamic> json) => WalletSummaryResponse(
    error: json["error"],
    message: json["message"],
    walletSummary: json["wallet_summary"] != null ? WalletSummary.fromJson(json["wallet_summary"]) : null,
  );
}

class WalletSummary {
  final double balance;
  final int totalTransactions;

  WalletSummary({
    required this.balance,
    required this.totalTransactions,
  });

  factory WalletSummary.fromJson(Map<String, dynamic> json) => WalletSummary(
    balance: (json['balance'] ?? 0).toDouble(),
    totalTransactions: json['total_transactions'] ?? 0,
  );
}
