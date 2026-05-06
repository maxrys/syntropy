
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DatePickerCustom: View {

    struct Value: Equatable {
        var date: Date
        var zone: String
        var result: Date {
            if let offsetNumeric = Date.TIME_ZONES_OFFSSET[self.zone]
                 { return self.date.toNewTimeZone(offset: offsetNumeric) }
            else { return self.date }
        }
    }

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var value: Value

    private let yearMinValue: Int
    private let yearMaxValue: Int

    init(
        value: Binding<Value>,
        yearMinValue: Int = 1970,
        yearMaxValue: Int = 2050
    ) {
        self.yearMinValue = yearMinValue
        self.yearMaxValue = yearMaxValue
        self._value = value
    }

    private var dayItems: [Int: String] {
        let daysInMonth = Date.daysInMonth(month: self.value.date.monthUTC, year: self.value.date.yearUTC)
        return (1 ... (daysInMonth ?? 31)).reduce(into: [Int: String]()) { result, value in
            result[value] = value < 10 ? "\u{2002}\(value)" : "\(value)"
        }
    }

    private var yearItems: [Int: String] {
        (self.yearMinValue ... self.yearMaxValue).reduce(into: [Int: String]()) { result, value in
            result[value] = "\(value)"
        }
    }

    static private let hourItems: [Int: String] = {
        (0 ... 23).reduce(into: [Int: String]()) { result, value in
            result[value] = value < 10 ? "0\(value)" : "\(value)"
        }
    }()

    static private let minuteAndSecondItems: [Int: String] = {
        (0 ... 59).reduce(into: [Int: String]()) { result, value in
            result[value] = value < 10 ? "0\(value)" : "\(value)"
        }
    }()

    var body: some View {
        HStack(spacing: 0) {

            VStack(alignment: .trailing, spacing: 14) {
                Text(NSLocalizedString("Date"    , comment: ""))
                Text(NSLocalizedString("Time"    , comment: ""))
                Text(NSLocalizedString("TimeZone", comment: ""))
            }
            .font(.headline)
            .lineLimit(1)

            VStack(alignment: .leading, spacing: 10) {

                HStack(spacing: 0) {
                    FieldList<Int>(
                        value: self.value.date.dayUTC,
                        items: self.dayItems,
                        onChange: { value in
                            self.value.date.dayUTC = value
                        }
                    ).frame(width: 60)

                    FieldList<Int>(
                        value: self.value.date.monthUTC,
                        items: Date.MONTH_NAMES,
                        onChange: { value in
                            self.updateMonth(value)
                        }
                    ).frame(width: 120)

                    FieldList<Int>(
                        value: self.value.date.yearUTC,
                        items: self.yearItems,
                        onChange: { value in
                            self.updateYear(value)
                        }
                    ).frame(width: 72)
                }

                HStack(spacing: 0) {
                    FieldList<Int>(
                        value: self.value.date.hourUTC,
                        items: Self.hourItems,
                        onChange: { value in
                            self.value.date.hourUTC = value
                        }
                    ).frame(width: 60)

                    FieldList<Int>(
                        value: self.value.date.minuteUTC,
                        items: Self.minuteAndSecondItems,
                        onChange: { value in
                            self.value.date.minuteUTC = value
                        }
                    ).frame(width: 60)

                    FieldList<Int>(
                        value: self.value.date.secondUTC,
                        items: Self.minuteAndSecondItems,
                        onChange: { value in
                            self.value.date.secondUTC = value
                        }
                    ).frame(width: 60)
                }

                FieldGrouppedList<Int, String>(
                    value: self.value.zone,
                    list: Date.TIME_ZONES_GROUPPED_LIST,
                    onChange: { value in
                        self.value.zone = value
                    }
                ).frame(width: 180)

            }

        }
    }

    private func updateMonth(_ newMonth: Int) {
        var resultDate = self.value.date
        if let daysInMonth = Date.daysInMonth(month: newMonth, year: resultDate.yearUTC) {
            if (resultDate.dayUTC > daysInMonth) {
                resultDate.dayUTC = daysInMonth
            }
        }
        resultDate.monthUTC = newMonth
        if (resultDate != self.value.date) {
            self.value.date = resultDate
        }
    }

    private func updateYear(_ newYear: Int) {
        var resultDate = self.value.date
        if let daysInMonth = Date.daysInMonth(month: resultDate.monthUTC, year: newYear) {
            if (resultDate.dayUTC > daysInMonth) {
                resultDate.dayUTC = daysInMonth
            }
        }
        resultDate.yearUTC = newYear
        if (resultDate != self.value.date) {
            self.value.date = resultDate
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct DatePickerCustom_Previews: PreviewProvider {
    static public var previews: some View {
        DatePickerCustom(
            value: .constant(
                DatePickerCustom.Value(
                    date: Date(iso8601: "2000-01-01 00:00:00")!,
                    zone: "UTC"
                )
            )
        )
        .padding(20)
        .frame(width: 400)
    }
}

