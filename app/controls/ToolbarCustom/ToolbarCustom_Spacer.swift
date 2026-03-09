
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_Spacer: ToolbarCustom_Item_Protocol {

    let flexibility: Flexibility

    init(flexibility: Flexibility = .size(30)) {
        self.flexibility = flexibility
    }

    public var body: some View {
        Color.clear
            .frame(height: 30)
            .flexibility(self.flexibility)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ToolbarCustom_Preview.previews
}
