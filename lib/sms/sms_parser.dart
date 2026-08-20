class ParsedSmsData {
  final double amount;
  final String merchant;
  final bool isIncome;

  ParsedSmsData({
    required this.amount,
    required this.merchant,
    required this.isIncome,
  });
}

class SmsParser {
  // --- TELEBIRR PATTERNS ---
  // Matches: "...paid Birr 150.50 to John Doe."
  static final RegExp _telebirrExpense = RegExp(r"(?i)paid\s+(?:birr|etb)\s+([\d,]+(?:\.\d+)?)\s+to\s+(.*?)(?:\.|\s+Your|$)");

  // Matches: "...received Birr 500.00 from Jane Doe."
  static final RegExp _telebirrIncome = RegExp(r"(?i)received\s+(?:birr|etb)\s+([\d,]+(?:\.\d+)?)\s+from\s+(.*?)(?:\.|\s+Your|$)");

  // --- CBE (Commercial Bank of Ethiopia) PATTERNS ---
  // Matches: "Dear Customer, Birr 1,500.00 is debited..."
  static final RegExp _cbeDebit = RegExp(r"(?i)(?:birr|etb)\s+([\d,]+(?:\.\d+)?)\s+(?:is|has\s+been)\s+debited");

  // Matches: "Dear Customer, Birr 1000.00 is credited..."
  static final RegExp _cbeCredit = RegExp(r"(?i)(?:birr|etb)\s+([\d,]+(?:\.\d+)?)\s+(?:is|has\s+been)\s+credited");

  // Helper regexes to extract the name associated with a CBE transaction
  static final RegExp _cbeMerchantTo = RegExp(r"(?i)(?:transfer\s+to|purchase\s+from)\s+(.*?)(?:\.|\s+on\s+|$)");
  static final RegExp _cbeMerchantFrom = RegExp(r"(?i)(?:from|by)\s+(.*?)(?:\.|\s+on\s+|$)");

  static ParsedSmsData? parseExpense(String messageBody, String sender) {
    final cleanBody = messageBody.replaceAll('\n', ' ').trim();
    final lowerSender = sender.toLowerCase();

    if (lowerSender.contains('telebirr') || lowerSender.contains('127')) {
      return _parseTelebirr(cleanBody);
    } else if (lowerSender.contains('cbe') || lowerSender.contains('commercial')) {
      return _parseCbe(cleanBody);
    }
    return null;
  }

  static ParsedSmsData? _parseTelebirr(String body) {
    final expenseMatch = _telebirrExpense.firstMatch(body);
    if (expenseMatch != null) {
      return ParsedSmsData(
        amount: _parseAmount(expenseMatch.group(1)!),
        merchant: expenseMatch.group(2)!.trim(),
        isIncome: false,
      );
    }

    final incomeMatch = _telebirrIncome.firstMatch(body);
    if (incomeMatch != null) {
      return ParsedSmsData(
        amount: _parseAmount(incomeMatch.group(1)!),
        merchant: incomeMatch.group(2)!.trim(),
        isIncome: true,
      );
    }
    return null;
  }

  static ParsedSmsData? _parseCbe(String body) {
    final debitMatch = _cbeDebit.firstMatch(body);
    if (debitMatch != null) {
      final merchantMatch = _cbeMerchantTo.firstMatch(body);
      final merchantName = merchantMatch?.group(1)?.trim() ?? 'CBE Transaction';

      return ParsedSmsData(
        amount: _parseAmount(debitMatch.group(1)!),
        merchant: merchantName,
        isIncome: false,
      );
    }

    final creditMatch = _cbeCredit.firstMatch(body);
    if (creditMatch != null) {
      final senderMatch = _cbeMerchantFrom.firstMatch(body);
      final senderName = senderMatch?.group(1)?.trim() ?? 'CBE Deposit';

      return ParsedSmsData(
        amount: _parseAmount(creditMatch.group(1)!),
        merchant: senderName,
        isIncome: true,
      );
    }
    return null;
  }

  static double _parseAmount(String amountStr) {
    return double.tryParse(amountStr.replaceAll(',', '')) ?? 0.0;
  }
}