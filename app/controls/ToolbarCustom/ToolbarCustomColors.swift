
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct ToolbarCustomColorSet {
        public let icon                    = Color.black.opacity(0.5)
        public let iconDark                = Color.white.opacity(0.6)
        public let iconBorder              = Color.black.opacity(0.05)
        public let iconBorderDark          = Color.white.opacity(0.05)
        public let title                   = Color.black.opacity(0.5)
        public let titleDark               = Color.white.opacity(0.6)
        public let textFieldBackground     = Color.white.opacity(0.9)
        public let textFieldBackgroundDark = Color.white.opacity(0.1)
    }

    static let toolbar = ToolbarCustomColorSet()

}
