
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import ZIPFoundation

@main struct ThisApp: App {

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

                Button("Archivator.compress()") {
                    Archivator.compress(
                        from: Archivator.pathScanRecursuve(
                            "/Volumes/dev/xcode/syntropy/test/by_structure"
                        ),
                        to: Archivator.pathToSafePath(
                            "/Volumes/dev/xcode/syntropy/test/result/file.zip"
                        )
                    )
                }

            }
        }
    }

}
