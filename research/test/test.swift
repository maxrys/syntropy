
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import Testing

struct test {

    @Test func Date_daysInMonth() async throws {
        for year in 1970 ... 2050 {
            let isLeapYear = year % 4 == 0
            let daysInFeb = isLeapYear ? 29 : 28
            var days: Int
            var isSuccess: Bool
            days = Date.daysInMonth(month:  1, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month:  1 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  2, year: year) ?? 0; /* */ isSuccess = days == daysInFeb; /* */ Logger.customLog("Date_daysInMonth(): month:  2 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  3, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month:  3 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  4, year: year) ?? 0; /* */ isSuccess = days == 30;        /* */ Logger.customLog("Date_daysInMonth(): month:  4 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  5, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month:  5 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  6, year: year) ?? 0; /* */ isSuccess = days == 30;        /* */ Logger.customLog("Date_daysInMonth(): month:  6 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  7, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month:  7 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  8, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month:  8 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month:  9, year: year) ?? 0; /* */ isSuccess = days == 30;        /* */ Logger.customLog("Date_daysInMonth(): month:  9 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month: 10, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month: 10 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month: 11, year: year) ?? 0; /* */ isSuccess = days == 30;        /* */ Logger.customLog("Date_daysInMonth(): month: 11 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
            days = Date.daysInMonth(month: 12, year: year) ?? 0; /* */ isSuccess = days == 31;        /* */ Logger.customLog("Date_daysInMonth(): month: 12 | year: \(year) | days: \(days) | \(isSuccess ? "success" : "!!! FAILURE !!!")"); /* */ #expect(isSuccess)
        }
    }

}
