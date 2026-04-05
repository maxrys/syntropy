
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TimelineViewPolyfill<Content: View>: View {

    private let interval: TimeInterval
    private let content: () -> Content

    init(
        by interval: TimeInterval,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.interval = interval
        self.content = content
    }

    public var body: some View {
        if #available(macOS 12.0, *) {
            TimelineView(.periodic(from: .nowPolyfill, by: self.interval)) { _ in
                self.content()
            }
        } else {
            self.content()
        }
    }

}
