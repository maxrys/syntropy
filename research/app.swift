
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

@main struct ThisApp: App {

    enum Tab: Hashable {
        case compressPublisherView
        case compressAsyncView
        case fileManagerView
    }

    @State private var selection: Tab = .compressAsyncView

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                CompressPublisherView()
                    .tabItem { Label("CompressPublisherView", systemImage: "1.circle") }
                    .tag(Tab.compressPublisherView)
                CompressAsyncView()
                    .tabItem { Label("CompressAsyncView", systemImage: "2.circle") }
                    .tag(Tab.compressAsyncView)
                FileManagerView()
                    .tabItem { Label("FileManagerView", systemImage: "3.circle") }
                    .tag(Tab.fileManagerView)
            }.padding(20)
        }
    }

}
