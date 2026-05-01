
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct RadioButton: View {

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var selected: UInt?

    private let ID: UInt
    private let content: any View
    private let size: CGFloat
    private let indicatorAlignment: VerticalAlignment
    private let isDisabled: Bool

    init(
        ID: UInt,
        _ selected: Binding<UInt?>,
        size: CGFloat = 20,
        indicatorAlignment: VerticalAlignment = .top,
        isDisabled: Bool = false,
        @ViewBuilder content: () -> any View
    ) {
        self.ID = ID
        self._selected = selected
        self.size = size
        self.indicatorAlignment = indicatorAlignment
        self.isDisabled = isDisabled
        self.content = content()
    }

    var body: some View {
        HStack(alignment: self.indicatorAlignment, spacing: 10) {
            Button { self.selected = self.ID } label: {
                Circle()
                    .fill(
                        self.colorScheme == .dark ?
                            Color.black :
                            Color.white
                    )
                    .frame(
                        width : self.size,
                        height: self.size
                    )
                    .overlayPolyfill {
                        self.BorderView()
                    }
                    .overlayPolyfill {
                        if (self.selected == self.ID) {
                            self.IndicatorView()
                        }
                    }
                    .clipShape   (Circle())
                    .contentShape(Circle())
                    .focusEffect (Circle())
            }
            .buttonStyle(.plain)
            .disabled(self.isDisabled)
            .pointerStyleLinkPolyfill()

            AnyView(
                self.content
            ).opacity(
                self.isDisabled ? 0.3 : 1.0
            )
        }
    }

    @ViewBuilder private func BorderView() -> some View {
        Circle()
            .stroke(
                self.colorScheme == .dark ?
                    Color.white.opacity(0.3) :
                    Color.black.opacity(0.3),
                lineWidth: 2
            )
            .frame(
                width : self.size,
                height: self.size
            )
    }

    @ViewBuilder private func IndicatorView() -> some View {
        Circle()
            .fill(Color.accentColor)
            .frame(
                width : self.size * 0.7,
                height: self.size * 0.7
            )
    }

}


/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct RadioButton_Previews: PreviewProvider {
    struct ViewWithState: View {
        static let DEMO_ID_0: UInt = 0
        static let DEMO_ID_1: UInt = 1
        static let DEMO_ID_2: UInt = 2
        @State private var selected: UInt? = 0
        public var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                RadioButton(ID: Self.DEMO_ID_0, self.$selected) {
                    Text("Item 1")
                }
                RadioButton(ID: Self.DEMO_ID_1, self.$selected) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Item 2")
                        Text("some description 1").font(.system(size: 10))
                        Text("some description 2").font(.system(size: 10))
                        Text("some description 3").font(.system(size: 10))
                    }
                }
                RadioButton(ID: Self.DEMO_ID_2, self.$selected, isDisabled: true) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Item 3")
                        Text("disabled").font(.system(size: 10))
                    }
                }
            }.padding(20)
        }
    }
    static public var previews: some View {
        ViewWithState()
    }
}
