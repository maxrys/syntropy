
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Date {

    static var defaultFPS = 1.0 / 24

    static func spin(max: UInt, speed: Double) -> Double {
        Double(UInt(Self().timeIntervalSince1970 * speed) % max)
    }

    var ISO8601Mono: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let mSec = Int(Self().timeIntervalSince1970.fractionalPart * 1_000)
        return formatter.string(from: self) + "-\(mSec)"
    }

}
