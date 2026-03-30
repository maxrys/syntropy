
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct NSColorSet {
        subscript(_ keyPath: KeyPath<NSColor.Type, NSColor>) -> Color {
            Color(NSColor.self[
                keyPath: keyPath
            ])
        }
    }

    static let NS = NSColorSet()

    static let label: Color = {
        Self.NS[\.labelColor]
    }()

}
