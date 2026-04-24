package com.example.track_birr.sms

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import com.example.track_birr.data.local.Expense
import com.example.track_birr.data.repository.ExpenseRepository
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class SmsReceiver : BroadcastReceiver() {

    @Inject
    lateinit var parser: SmsParser

    @Inject
    lateinit var repository: ExpenseRepository

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            val pendingResult = goAsync()
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)

            CoroutineScope(Dispatchers.IO).launch {
                try {
                    for (message in messages) {
                        val sender = message.originatingAddress ?: continue
                        val body = message.messageBody ?: continue

                        val parsedData = parser.parseExpense(body, sender)
                        
                        if (parsedData != null) {
                            val expense = Expense(
                                amount = parsedData.amount,
                                merchantName = parsedData.merchant,
                                timestamp = message.timestampMillis,
                                bankOrTelecom = sender,
                                isIncome = parsedData.isIncome
                            )
                            
                            // Insert into Room database
                            repository.insertExpense(expense)
                        }
                    }
                } finally {
                    // Tell the OS we are done with the background work
                    pendingResult.finish()
                }
            }
        }
    }
}
