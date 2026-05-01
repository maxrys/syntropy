
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension View {

    @ViewBuilder func foregroundPolyfill(_ color: Color) -> some View {
        if #available(macOS 14.0, iOS 17.0, *) { self.foregroundStyle(color) }
        else                                   { self.foregroundColor(color) }
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

    @ViewBuilder func focusEffect<S>(_ shape: S) -> some View where S: Shape {
        if #available(macOS 12.0, *) {
            self.contentShape(.focusEffect, shape)
        } else {
            self
        }
    }

    @ViewBuilder func overlayPolyfill<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            self
            content()
        }
    }

}
