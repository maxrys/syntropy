
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import ZIPFoundation

@main struct ThisApp: App {

    @State private var isTrimPrefix: Bool = false

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 10) {

                Button("Archivator.pathToSafePath()") {
                    Logger.customLog( Archivator.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder") )
                    Logger.customLog( Archivator.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder.extension") )
                    Logger.customLog( Archivator.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension") )
                    Logger.customLog( Archivator.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file.txt") )
                }

                Button("Archivator.pathScanRecursuve()") {
                    dump(
                        Archivator.pathScanRecursuve(
                            "/Volumes/dev/xcode/syntropy/test/by_structure"
                        )
                    )
                }

                Button("Archivator.trimSharedPathPrefix()") {
                    dump(
                        Archivator.pathsTrimSharedPrefix([
                            "/Volumes/dev/xcode/syntropy/test/by_structure/nested folder 1/nested file 1.txt",
                            "/Volumes/dev/xcode/syntropy/test/by_structure/nested folder 2/nested file 5.txt",
                            "/Volumes/dev/xcode/syntropy/test/by_structure/file 1.txt",
                        ])
                    )
                }

                Button("Archivator.compress()") {
                    Archivator.compress(
                        from: Archivator.pathScanRecursuve(
                            "/Volumes/dev/xcode/syntropy/test/by_structure"
                        ),
                        to: Archivator.pathToSafePath(
                            "/Volumes/dev/xcode/syntropy/test/result/file.zip"
                        ),
                        isTrimPrefix: self.isTrimPrefix
                    )
                }

                Toggle(isOn: self.$isTrimPrefix) {
                    Text("Trim prefix")
                }

            }
        }
    }

}
