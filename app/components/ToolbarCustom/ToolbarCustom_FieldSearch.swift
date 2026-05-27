
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_FieldSearch: ToolbarCustom_Item_Protocol {

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var text: String

    let minWidth: CGFloat
    let maxWidth: CGFloat

    init(
        text: Binding<String>,
        minWidth: CGFloat,
        maxWidth: CGFloat
    ) {
        self._text = text
        self.minWidth = minWidth
        self.maxWidth = maxWidth
    }

    public var body: some View {
        FieldSearchCustom(text: self.$text)
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
