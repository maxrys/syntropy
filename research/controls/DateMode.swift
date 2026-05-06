
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DateMode: View {

    enum Mode {
        case original
        case current
        case custom
    }

    @Binding private var mode: Mode?
    @Binding private var dateWithTZ: DatePickerCustom.Value

    @State private var isPresentedCalendar: Bool = false

    init(
        mode: Binding<Mode?>,
        dateWithTZ: Binding<DatePickerCustom.Value>
    ) {
        self._mode       = mode
        self._dateWithTZ = dateWithTZ
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Date")
                .font(.headline)

            RadioButton(ID: .original, self.$mode) {
                Text("Original")
            }

            RadioButton(ID: .current, self.$mode, indicatorAlignment: self.mode == .current ? .top : .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                    if (self.mode == .current) {
                        TimelineViewPolyfill(by: 1) {
                            Text("\(Date().formatISO8601tz)")
                                .font(.system(size: 10))
                        }
                    }
                }
            }

            RadioButton(ID: .custom, self.$mode) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 7) {
                        Text("Custom")
                        if (self.mode == .custom) {
                            Button { self.isPresentedCalendar = true } label: {
                                Image(systemName: "calendar")
                                    .foregroundPolyfill(.accentColor)
                            }
                            .buttonStyle(.plain)
                            .pointerStyleLinkPolyfill()
                            .popover(isPresented: self.$isPresentedCalendar) {
                                DatePickerCustom(
                                    value: self.$dateWithTZ
                                ).padding(20)
                            }
                        }
                    }
                    if (self.mode == .custom) {
                        Text("\(self.dateWithTZ.result.formatISO8601tzUTC)")
                            .font(.system(size: 10))
                    }
                }
            }

        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct DateMode_Previews: PreviewProvider {
    struct ViewWithState: View {
        @State private var mode: DateMode.Mode? = .original
        @State private var dateWithTZ = DatePickerCustom.Value(
            date: Date(),
            zone: "UTC"
        )
        public var body: some View {
            DateMode(
                mode      : self.$mode,
                dateWithTZ: self.$dateWithTZ
            )
            .padding(20)
            .frame(width: 250, alignment: .leading)
        }
    }
    static public var previews: some View {
        ViewWithState()
    }
}
