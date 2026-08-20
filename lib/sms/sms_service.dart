import 'package:telephony/telephony.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_birr/sms/sms_parser.dart';
import 'package:track_birr/domain/models/expense.dart';
import 'package:track_birr/data/repository/expense_repository.dart';
import 'package:track_birr/providers/expense_providers.dart';

@pragma('vm:entry-point')
void backgroundMessageHandler(SmsMessage message) async {
  // Handle background message
  _processMessage(message);
}

void _processMessage(SmsMessage message, [ProviderContainer? container]) async {
  if (message.body == null || message.address == null) return;

  final sender = message.address!;
  final body = message.body!;

  final parsedData = SmsParser.parseExpense(body, sender);

  if (parsedData != null) {
    final expense = Expense(
      amount: parsedData.amount,
      merchantName: parsedData.merchant,
      timestamp: message.date ?? DateTime.now().millisecondsSinceEpoch,
      bankOrTelecom: sender,
      isIncome: parsedData.isIncome,
    );

    if (container != null) {
      container.read(expensesProvider.notifier).addExpense(expense);
    } else {
      final repo = ExpenseRepository();
      await repo.insertExpense(expense);
    }
  }
}

class SmsService {
  final Telephony telephony = Telephony.instance;
  final ProviderContainer? container;

  SmsService({this.container});

  void init() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted ?? false) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          _processMessage(message, container);
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
    }
  }
}