
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_TextField: ToolbarCustom_Item_Protocol {

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
