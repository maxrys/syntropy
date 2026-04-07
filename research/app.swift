
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

@main struct ThisApp: App {

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 50) {
                CompressAsyncView()
                FileManagerView()
            }.padding(50)
        }
    }

}
