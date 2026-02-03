
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

enum Flexibility {

    case none
    case size(CGFloat)
    case infinity

}

extension View {

    @ViewBuilder func flexibility(_ value: Flexibility = .none) -> some View {
        switch value {
            case .size(let size): self.frame(width: size)
            case .infinity      : self.frame(maxWidth: .infinity)
            case .none          : self
        }
    }

    @ViewBuilder func pointerStyleLinkPolyfill(isEnabled: Bool = true) -> some View {
        if (isEnabled) {
            if #available(macOS 15.0, *) {
                self.pointerStyle(.link)
            } else {
                self.onHover { isInView in
                    if (isInView) { NSCursor.pointingHand.push() }
                    else          { NSCursor.pop() }
                }
            }
        } else {
            self
        }
    }

}
