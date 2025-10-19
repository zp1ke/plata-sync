package org.zp1ke.platasync.util

import org.junit.Assert.assertEquals
import org.junit.Test

class FormatterAndroidTest {

    @Test
    fun `formatMoney should format zero amount correctly`() {
        val result = formatMoney(0)
        assertEquals("$0.00", result)
    }

    @Test
    fun `formatMoney should format positive amount correctly`() {
        val result = formatMoney(12345)
        assertEquals("$123.45", result)
    }

    @Test
    fun `formatMoney should format negative amount correctly`() {
        val result = formatMoney(-5000)
        assertEquals("-$50.00", result)
    }

    @Test
    fun `formatMoney should format large amount correctly`() {
        val result = formatMoney(100000000)
        assertEquals("$1,000,000.00", result)
    }

    @Test
    fun `formatMoney should format single cent correctly`() {
        val result = formatMoney(1)
        assertEquals("$0.01", result)
    }

    @Test
    fun `formatMoney should format 99 cents correctly`() {
        val result = formatMoney(99)
        assertEquals("$0.99", result)
    }

    @Test
    fun `formatMoney should format one dollar correctly`() {
        val result = formatMoney(100)
        assertEquals("$1.00", result)
    }

    @Test
    fun `formatMoney should format 78789867 correctly`() {
        val result = formatMoney(78789867)
        assertEquals("$787,898.67", result)
    }
}
