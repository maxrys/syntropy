
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

@main struct ThisApp: App {

    enum Tab: Hashable {
        case compressAsyncView
        case fileIteratorView
        case fileManagerView
    }

    @State private var selection: Tab = .compressAsyncView

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                CompressAsyncView()
                    .tabItem { Text("CompressAsyncView") }
                    .tag(Tab.compressAsyncView)
                FileIteratorView()
                    .tabItem { Text("FileIteratorView") }
                    .tag(Tab.fileIteratorView)
                FileManagerView()
                    .tabItem { Text("FileManagerView") }
                    .tag(Tab.fileManagerView)
            }.padding(20)
        }
    }

}
