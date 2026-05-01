
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DatePickerCustom: View {

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

    @Environment(\.colorScheme) private var colorScheme

    @Binding private var value: Date?

    @State private var day: Int    /* 1 ... 31 */
    @State private var month: Int  /* 1 ... 12 */
    @State private var year: Int   /* 1970 ... 2050 */
    @State private var hour: Int   /* 0 ... 23 */
    @State private var minute: Int /* 0 ... 59 */
    @State private var second: Int /* 0 ... 59 */
    @State private var timeZone: Int

    private let yearMinValue: Int
    private let yearMaxValue: Int

    init(
        value: Binding<Date?>,
        yearMinValue: Int = 1970,
        yearMaxValue: Int = 2050
    ) {
        self._value = value
        self.day      = Calendar.current.component(.day     , from: value.wrappedValue ?? Date())
        self.month    = Calendar.current.component(.month   , from: value.wrappedValue ?? Date())
        self.year     = Calendar.current.component(.year    , from: value.wrappedValue ?? Date())
        self.hour     = Calendar.current.component(.hour    , from: value.wrappedValue ?? Date())
        self.minute   = Calendar.current.component(.minute  , from: value.wrappedValue ?? Date())
        self.second   = Calendar.current.component(.second  , from: value.wrappedValue ?? Date())
        self.timeZone = 0
        self.yearMinValue = yearMinValue
        self.yearMaxValue = yearMaxValue
    }

    private let columns = [
        GridItem(.fixed( 80), spacing: 0, alignment: .trailing),
        GridItem(.fixed(120), spacing: 0, alignment: .leading),
    ]

    var body: some View {
        LazyVGrid(columns: self.columns, spacing: 10) {

            Text(NSLocalizedString("Day", comment: ""))
                .font(.headline)

            Picker("", selection: self.$day) {
                ForEach(1 ... 31, id: \.self) { dayNumber in
                    Text("\(String(dayNumber))")
                }
            }.frame(width: 60)

            Text(NSLocalizedString("Month", comment: ""))
                .font(.headline)

            Picker("", selection: self.$month) {
                ForEach(1 ... 12, id: \.self) { monthNumber in
                    if let monthName = Self.MONTH_NAMES[monthNumber]
                         { Text("\(monthName)") }
                    else { Text("\(String(monthNumber))") }
                }
            }.frame(width: 110)

            Text(NSLocalizedString("Year", comment: ""))
                .font(.headline)

            Picker("", selection: self.$year) {
                ForEach(self.yearMinValue ... self.yearMaxValue, id: \.self) { yearNumber in
                    Text("\(String(yearNumber))")
                }
            }.frame(width: 80)

            Text(NSLocalizedString("Hour", comment: ""))
                .font(.headline)

            Picker("", selection: self.$hour) {
                ForEach(0 ... 23, id: \.self) { hourNumber in
                    Text("\(String(hourNumber))")
                }
            }.frame(width: 60)

            Text(NSLocalizedString("Minute", comment: ""))
                .font(.headline)

            Picker("", selection: self.$minute) {
                ForEach(0 ... 59, id: \.self) { minuteNumber in
                    Text("\(String(minuteNumber))")
                }
            }.frame(width: 60)

            Text(NSLocalizedString("Second", comment: ""))
                .font(.headline)

            Picker("", selection: self.$second) {
                ForEach(0 ... 59, id: \.self) { secondNumber in
                    Text("\(String(secondNumber))")
                }
            }.frame(width: 60)

            Text(NSLocalizedString("TimeZone", comment: ""))
                .font(.headline)

            Picker("", selection: self.$timeZone) {
                ForEach(0 ... 12, id: \.self) { timeZoneNumber in
                    Text("\(String(timeZoneNumber))")
                }
            }.frame(width: 60)

        }
     // Text("\(self.value?.ISO8601withTZ)")
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct DatePickerCustom_Previews: PreviewProvider {
    static public var previews: some View {
        DatePickerCustom(
            value: .constant(Date())
        ).padding(20)
    }
}

