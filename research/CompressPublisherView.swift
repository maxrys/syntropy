
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import Combine
import ZIPFoundation

struct CompressPublisherView: View {

    private var compressPublisher: Cancellable?

    var body: some View {
        VStack(spacing: 10) {
        }
    }

    init() {
        self.compressPublisher = CompressPublisher(count: 10)
            .sink(receiveCompletion: { _ in
                print("finish")
            }, receiveValue: { value in
                print("\(value)")
            })
    }

}
