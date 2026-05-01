
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

    @State private var mode: Mode? = .custom
    @State private var date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Date")
                .font(.headline)

            RadioButton(ID: .original, self.$mode) {
                Text("Original")
            }

            RadioButton(ID: .current, self.$mode) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                    if (self.mode == .current) {
                        TimelineViewPolyfill(by: 1) {
                            Text("\(Date().ISO8601withTZ)")
                                .font(.system(size: 10))
                        }
                    }
                }
            }

            RadioButton(ID: .custom, self.$mode) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Custom")
                    if (self.mode == .custom) {
                        DatePicker("", selection: $date)
                            .datePickerStyle(.automatic)
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

