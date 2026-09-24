
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    enum ToolbarCustomColorSet {
        static let icon           = Color.black.opacity(0.5)
        static let iconDark       = Color.white.opacity(0.6)
        static let iconBorder     = Color.black.opacity(0.05)
        static let iconBorderDark = Color.white.opacity(0.05)
        static let title          = Color.black.opacity(0.5)
        static let titleDark      = Color.white.opacity(0.6)
    }

    static let toolbar = ToolbarCustomColorSet.self

}
