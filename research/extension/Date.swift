
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension Date {

    static public let MONTH_NAMES = [
         1: "January",
         2: "February",
         3: "March",
         4: "April",
         5: "May",
         6: "June",
         7: "July",
         8: "August",
         9: "September",
        10: "October",
        11: "November",
        12: "December",
    ]

    enum Format: String {
        case iso8601         = "yyyy-MM-dd HH:mm:ss"
        case iso8601Timezone = "yyyy-MM-dd HH:mm:ss Z"
        case iso8601Mono     = "yyyyMMdd_HHmmss"
        case convenientDate  = "d MMM yyyy"
        case convenientTime  = "HH:mm:ss"
    }

    init?(iso8601: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = Format.iso8601.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = formatter.date(from: iso8601) {
            self = date
        } else {
            return nil
        }
    }

    init?(day: Int, month: Int, year: Int, hour: Int, minute: Int, second: Int) {
        var components = DateComponents()
        components.day    = day
        components.month  = month
        components.year   = year
        components.hour   = hour
        components.minute = minute
        components.second = second
        if let date = Self.UTCCalendar.date(from: components) {
            self = date
        } else {
            return nil
        }
    }

    var formatConvenient: String {
        let formatter = DateFormatter()
        formatter.dateFormat = String(
            format: NSLocalizedString("%@ 'at' %@", comment: ""),
            Self.Format.convenientDate.rawValue,
            Self.Format.convenientTime.rawValue )
        return formatter.string(from: self)
    }

    var formatISO8601tz: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.Format.iso8601Timezone.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    var formatISO8601tzUTC: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.Format.iso8601Timezone.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }

    var formatISO8601Mono: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.Format.iso8601Mono.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let mSec = Int(Self().timeIntervalSince1970.fractionalPart * 1_000)
        return formatter.string(from: self) + "-\(mSec)"
    }

    var dayUTC   : Int { get { Self.UTCCalendar.component(.day   , from: self) } set { self._updateComponent(day   : newValue) } }
    var monthUTC : Int { get { Self.UTCCalendar.component(.month , from: self) } set { self._updateComponent(month : newValue) } }
    var yearUTC  : Int { get { Self.UTCCalendar.component(.year  , from: self) } set { self._updateComponent(year  : newValue) } }
    var hourUTC  : Int { get { Self.UTCCalendar.component(.hour  , from: self) } set { self._updateComponent(hour  : newValue) } }
    var minuteUTC: Int { get { Self.UTCCalendar.component(.minute, from: self) } set { self._updateComponent(minute: newValue) } }
    var secondUTC: Int { get { Self.UTCCalendar.component(.second, from: self) } set { self._updateComponent(second: newValue) } }

    static public var UTCCalendar: Calendar {
        var result = Calendar(identifier: .gregorian)
        result.timeZone = TimeZone(secondsFromGMT: 0)!
        return result
    }

    static public func daysInMonth(month: Int, year: Int) -> Int? {
        guard month >= 1 && month <= 12 else { return nil }
        guard let dateStart =             Date(day: 1, month: month,     year: year    , hour: 0, minute: 0, second: 0) else { return nil }
        guard let dateEnd = month <= 11 ? Date(day: 1, month: month + 1, year: year    , hour: 0, minute: 0, second: 0) :
                                          Date(day: 1, month: 1        , year: year + 1, hour: 0, minute: 0, second: 0) else { return nil }
        let startDay   = Self.UTCCalendar.startOfDay(for: dateStart)
        let endDay     = Self.UTCCalendar.startOfDay(for: dateEnd)
        let components = Self.UTCCalendar.dateComponents([.day], from: startDay, to: endDay)
        return components.day
    }

    public func toNewTimeZone(offset seconds: Int) -> Self {
        self.addingTimeInterval(TimeInterval(seconds))
    }

    private mutating func _updateComponent(
        day   : Int? = nil,
        month : Int? = nil,
        year  : Int? = nil,
        hour  : Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
    ) {
        if let date = Date(
            day   : day    ?? Self.UTCCalendar.component(.day   , from: self),
            month : month  ?? Self.UTCCalendar.component(.month , from: self),
            year  : year   ?? Self.UTCCalendar.component(.year  , from: self),
            hour  : hour   ?? Self.UTCCalendar.component(.hour  , from: self),
            minute: minute ?? Self.UTCCalendar.component(.minute, from: self),
            second: second ?? Self.UTCCalendar.component(.second, from: self),
        ) {
            self = date
        }
    }

}
