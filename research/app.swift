
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

@main struct ThisApp: App {

    enum Tab: Hashable {
        case compressCoreView
        case compressAsyncView
        case fileManagerView
    }

    @State private var selection: Tab = .compressCoreView

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                CompresCoreView()
                    .tabItem { Text("CompresCoreView") }
                    .tag(Tab.compressCoreView)
                CompressAsyncView()
                    .tabItem { Text("CompressAsyncView") }
                    .tag(Tab.compressAsyncView)
                FileManagerView()
                    .tabItem { Text("FileManagerView") }
                    .tag(Tab.fileManagerView)
            }.padding(20)
        }
    }

}
