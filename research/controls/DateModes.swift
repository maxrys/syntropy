
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DateModes: View {

    enum Mode {
        case original
        case current
        case custom
    }

    @State private var isPresentedCalendar: Bool = false
    @State private var mode: Mode? = .custom
    @State private var dateWithTZ = DatePickerCustom.Value(
        date: Date(),
        zone: "UTC"
    )

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

        }.padding(20)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct DateModes_Previews: PreviewProvider {
    static public var previews: some View {
        DateModes()
    }
}

