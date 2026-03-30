
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_TextField: ToolbarCustom_Item_Protocol {

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var text: String

    let hint: String
    let minWidth: CGFloat
    let maxWidth: CGFloat

    init(
        hint: String,
        text: Binding<String>,
        minWidth: CGFloat,
        maxWidth: CGFloat
    ) {
        self.hint = hint
        self._text = text
        self.minWidth = minWidth
        self.maxWidth = maxWidth
    }

    public var body: some View {
        TextField(
            NSLocalizedString("Search", comment: ""),
            text: self.$text
        )
        .textFieldStyle(.plain)
        .padding(.horizontal, 32)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(
                    self.colorScheme == .dark ?
                        Color.toolbar.textFieldBackgroundDark :
                        Color.toolbar.textFieldBackground
                )
        )
        .overlayPolyfill(alignment: .leading) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundPolyfill(Color.label.opacity(0.3))
                .offset(x: 8)
        }
        .overlayPolyfill(alignment: .trailing) {
            if (!self.text.isEmpty) {
                Button { self.text = "" } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 16))
                        .foregroundPolyfill(Color.label.opacity(0.3))
                        .background(self.colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(Circle())
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .pointerStyleLinkPolyfill()
                .offset(x: -5)
            }
        }
        .frame(
            minWidth: self.minWidth,
            maxWidth: self.maxWidth
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ToolbarCustom_Preview.previews
}
