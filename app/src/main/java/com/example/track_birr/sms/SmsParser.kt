package com.example.track_birr.sms

import javax.inject.Inject

data class ParsedSmsData(
    val amount: Double,
    val merchant: String,
    val isIncome: Boolean
)

class SmsParser @Inject constructor() {

    companion object {
        // --- TELEBIRR PATTERNS ---
        // Matches: "...paid Birr 150.50 to John Doe."
        private val TELEBIRR_EXPENSE = Regex("(?i)paid\\s+(?:birr|etb)\\s+([\\d,]+(?:\\.\\d+)?)\\s+to\\s+(.*?)(?:\\.|\\s+Your|$)")
        
        // Matches: "...received Birr 500.00 from Jane Doe."
        private val TELEBIRR_INCOME = Regex("(?i)received\\s+(?:birr|etb)\\s+([\\d,]+(?:\\.\\d+)?)\\s+from\\s+(.*?)(?:\\.|\\s+Your|$)")

        // --- CBE (Commercial Bank of Ethiopia) PATTERNS ---
        // CBE messages can vary greatly, so we first identify the amount/direction, then attempt to extract the merchant/sender.
        // Matches: "Dear Customer, Birr 1,500.00 is debited..."
        private val CBE_DEBIT = Regex("(?i)(?:birr|etb)\\s+([\\d,]+(?:\\.\\d+)?)\\s+(?:is|has\\s+been)\\s+debited")
        
        // Matches: "Dear Customer, Birr 1000.00 is credited..."
        private val CBE_CREDIT = Regex("(?i)(?:birr|etb)\\s+([\\d,]+(?:\\.\\d+)?)\\s+(?:is|has\\s+been)\\s+credited")
        
        // Helper regexes to extract the name associated with a CBE transaction
        private val CBE_MERCHANT_TO = Regex("(?i)(?:transfer\\s+to|purchase\\s+from)\\s+(.*?)(?:\\.|\\s+on\\s+|$)")
        private val CBE_MERCHANT_FROM = Regex("(?i)(?:from|by)\\s+(.*?)(?:\\.|\\s+on\\s+|$)")
    }

    /**
     * Parses an incoming SMS message to determine if it's a financial transaction.
     * @param messageBody The full text of the SMS.
     * @param sender The sender ID (e.g., 'telebirr', 'CBE').
     * @return ParsedSmsData if a transaction is found, null otherwise.
     */
    fun parseExpense(messageBody: String, sender: String): ParsedSmsData? {
        val cleanBody = messageBody.replace("\n", " ").trim()
        val lowerSender = sender.lowercase()

        return when {
            lowerSender.contains("telebirr") || lowerSender.contains("127") -> parseTelebirr(cleanBody)
            lowerSender.contains("cbe") || lowerSender.contains("commercial") -> parseCbe(cleanBody)
            else -> null // We can add Awash Bank, Dashen Bank, etc. later here
        }
    }

    private fun parseTelebirr(body: String): ParsedSmsData? {
        TELEBIRR_EXPENSE.find(body)?.let { match ->
            return ParsedSmsData(
                amount = parseAmount(match.groupValues[1]),
                merchant = match.groupValues[2].trim(),
                isIncome = false
            )
        }

        TELEBIRR_INCOME.find(body)?.let { match ->
            return ParsedSmsData(
                amount = parseAmount(match.groupValues[1]),
                merchant = match.groupValues[2].trim(),
                isIncome = true
            )
        }

        return null
    }

    private fun parseCbe(body: String): ParsedSmsData? {
        CBE_DEBIT.find(body)?.let { match ->
            val merchantMatch = CBE_MERCHANT_TO.find(body)
            val merchantName = merchantMatch?.groupValues?.get(1)?.trim() ?: "CBE Transaction"
            
            return ParsedSmsData(
                amount = parseAmount(match.groupValues[1]),
                merchant = merchantName,
                isIncome = false
            )
        }

        CBE_CREDIT.find(body)?.let { match ->
            val senderMatch = CBE_MERCHANT_FROM.find(body)
            val senderName = senderMatch?.groupValues?.get(1)?.trim() ?: "CBE Deposit"
            
            return ParsedSmsData(
                amount = parseAmount(match.groupValues[1]),
                merchant = senderName,
                isIncome = true
            )
        }

        return null
    }

    /**
     * Cleans standard thousands separators to parse string amounts into Doubles.
     * Example: "1,500.50" -> 1500.5
     */
    private fun parseAmount(amountStr: String): Double {
        return amountStr.replace(",", "").toDoubleOrNull() ?: 0.0
    }
}
