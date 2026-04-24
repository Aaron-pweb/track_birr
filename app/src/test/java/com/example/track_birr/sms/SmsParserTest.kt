package com.example.track_birr.sms

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class SmsParserTest {

    private val parser = SmsParser()

    @Test
    fun testTelebirrExpense() {
        val sms = "Dear customer, you have paid Birr 150.50 to Local Supermarket. Your current balance is Birr 10.00."
        val result = parser.parseExpense(sms, "telebirr")

        assertNotNull(result)
        assertEquals(150.50, result!!.amount, 0.0)
        assertEquals("Local Supermarket", result.merchant)
        assertFalse(result.isIncome)
    }

    @Test
    fun testTelebirrIncome() {
        val sms = "Dear customer, you have received Birr 500.00 from John Doe. Your current balance is Birr 510.00."
        val result = parser.parseExpense(sms, "127") // 127 is standard telebirr shortcode

        assertNotNull(result)
        assertEquals(500.0, result!!.amount, 0.0)
        assertEquals("John Doe", result.merchant)
        assertTrue(result.isIncome)
    }

    @Test
    fun testCbeDebit() {
        val sms = "Dear Customer, Birr 1,200.00 is debited from your A/C on 01/01/2023. Reason: Transfer to Abebe."
        val result = parser.parseExpense(sms, "CBE")

        assertNotNull(result)
        assertEquals(1200.0, result!!.amount, 0.0)
        assertEquals("Abebe", result.merchant)
        assertFalse(result.isIncome)
    }

    @Test
    fun testCbeCredit() {
        val sms = "Dear Customer, ETB 50,000.00 is credited to your A/C. Transfer by Jane Smith."
        val result = parser.parseExpense(sms, "Commercial Bank")

        assertNotNull(result)
        assertEquals(50000.0, result!!.amount, 0.0)
        assertEquals("Jane Smith", result.merchant)
        assertTrue(result.isIncome)
    }

    @Test
    fun testUnknownFormatReturnsNull() {
        val sms = "Happy New Year! Get 50% off at our store."
        val result = parser.parseExpense(sms, "telebirr")

        assertNull(result)
    }
}
