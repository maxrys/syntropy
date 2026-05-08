
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DateMode: View {

    enum Mode: Equatable {
        case original
        case current
        case custom(DatePickerCustom.Value)
    }

    @Binding private var mode: Mode

    @State private var isPresentedCalendar: Bool = false
    @State private var customValue = DatePickerCustom.Value(
        date: Date(),
        zone: "UTC"
    )

    init(mode: Binding<Mode>) {
        self._mode = mode
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Date")
                .font(.headline)

            RadioButtonSimple(
                isSelected: { if case .original = self.mode { true } else { false } }(),
                onSelect: { self.mode = .original }
            ) {
                Text("Original")
            }

            RadioButtonSimple(
                isSelected: { if case .current = self.mode { true } else { false } }(),
                onSelect: { self.mode = .current }
            ) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                    if case .current = self.mode {
                        TimelineViewPolyfill(by: 1) {
                            Text("\(Date().formatISO8601tz)")
                                .font(.system(size: 10))
                        }
                    }
                }
            }

            RadioButtonSimple(
                isSelected: { if case .custom = self.mode { true } else { false } }(),
                onSelect: { self.mode = .custom(self.customValue) }
            ) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 7) {
                        Text("Custom")
                        if case .custom = self.mode {
                            Button { self.isPresentedCalendar = true } label: {
                                Image(systemName: "calendar")
                                    .foregroundPolyfill(.accentColor)
                            }
                            .buttonStyle(.plain)
                            .pointerStyleLinkPolyfill()
                            .popover(isPresented: self.$isPresentedCalendar, arrowEdge: .top) {
                                DatePickerCustom(
                                    value: self.$customValue
                                ).padding(20)
                            }
                        }
                    }
                    if case .custom = self.mode {
                        Text("\(self.customValue.offsetted.formatISO8601tzUTC)")
                            .font(.system(size: 10))
                    }
                }
            }

        }.onChange(of: self.customValue) { value in
            self.mode = .custom(value)
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct DateMode_Previews: PreviewProvider {
    struct ViewWithState: View {
        @State private var mode: DateMode.Mode = .original
        public var body: some View {
            DateMode(mode: self.$mode)
                .padding(20)
                .frame(width: 250, alignment: .leading)
        }
    }
    static public var previews: some View {
        ViewWithState()
    }
}
