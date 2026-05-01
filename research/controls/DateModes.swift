
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DateModes: View {

    static let SELECTOR_ORIGINAL_ID: UInt = 0
    static let SELECTOR_CURRENT_ID: UInt = 1
    static let SELECTOR_CUSTOM_ID: UInt = 2

    @State private var mode: UInt? = 3
    @State private var date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Date")
                .font(.headline)

            RadioButton(ID: Self.SELECTOR_ORIGINAL_ID, self.$mode) {
                Text("Original")
            }

            RadioButton(ID: Self.SELECTOR_CURRENT_ID, self.$mode) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                    TimelineViewPolyfill(by: 1) {
                        Text("\(Date().ISO8601withTZ)")
                            .font(.system(size: 10))
                    }
                }
            }

            RadioButton(ID: Self.SELECTOR_CUSTOM_ID, self.$mode) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Custom")
                    if (self.mode == Self.SELECTOR_CUSTOM_ID) {
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
            .frame(width: 300)
    }
}

