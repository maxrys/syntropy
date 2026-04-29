
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

@main struct ThisApp: App {

    enum Tab: Hashable {
        case compresSequence
        case fileManager
    }

    @State private var selection: Tab = .compresSequence

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                CompresSequenceView()
                    .tabItem { Text("Compress Sequence") }
                    .tag(Tab.compresSequence)
                FileManagerView()
                    .tabItem { Text("File Manager") }
                    .tag(Tab.fileManager)
            }.padding(20)
        }
    }

}
