
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TimelineViewPolyfill<Content: View>: View {

    @ObservedObject private var frameNumber = ValueState<UInt>(0)

    private let interval: TimeInterval
    private let content: () -> Content
    private var timer: Timer.Custom!

    init(
        by interval: TimeInterval,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.interval = interval
        self.content = content
        if #available(macOS 12.0, *) {} else {
            self.timer = Timer.Custom(
                repeats: .infinity,
                delay: self.interval,
                onTick: self.onTick
            )
        }
    }

    private func onTick(timer: Timer.Custom) {
        self.frameNumber.value += 1
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
