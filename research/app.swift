
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

@main struct ThisApp: App {

    enum Tab: Hashable {
        case compressSequence
        case fileIterator
        case fileManager
    }

    @State private var selection: Tab = .compressSequence

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                CompresSequenceView()
                    .tabItem { Text("Compres Sequence") }
                    .tag(Tab.compressSequence)
                FileIteratorView()
                    .tabItem { Text("File Iterator") }
                    .tag(Tab.fileIterator)
                FileManagerView()
                    .tabItem { Text("File Manager") }
                    .tag(Tab.fileManager)
            }.padding(20)
        }
    }

}
