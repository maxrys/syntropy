
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct Settings: View {

    public var body: some View {
        TabCustom {
            TabCustom_Item(
                title: NSLocalizedString("Extraction", comment: ""),
                icon: Image(systemName: "tray.and.arrow.up"),
                content: { Settings_Extraction() })
            TabCustom_Item(
                title: NSLocalizedString("Compression", comment: ""),
                icon: Image(systemName: "tray.and.arrow.down"),
                content: { Settings_Compression() })
            TabCustom_Item(
                title: NSLocalizedString("Presets", comment: ""),
                icon: Image(systemName: "rectangle.grid.3x1"),
                content: { Settings_Presets() }
            )
        }
        .frame(
            maxWidth : .infinity,
            maxHeight: .infinity
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Settings()
        .frame(width: 300, height: 300)
}
