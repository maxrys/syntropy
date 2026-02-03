
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_TextField: ToolbarCustom_item_Protocol {

    @Environment(\.colorScheme) private var colorScheme

    @Binding private var text: String

    let hint: String
    let onChange: () -> Void
    let minWidth: CGFloat
    let maxWidth: CGFloat

    init(
        hint: String,
        text: Binding<String>,
        minWidth: CGFloat,
        maxWidth: CGFloat,
        onChange: @escaping () -> Void
    ) {
        self.hint = hint
        self._text = text
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.onChange = onChange
    }

    public var body: some View {
        TextField(self.hint, text: self.$text)
            .multilineTextAlignment(.center)
            .textFieldStyle(.roundedBorder)
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
