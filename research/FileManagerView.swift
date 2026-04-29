
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct FileManagerView: View {

    var body: some View {
        VStack(spacing: 10) {

            Button("FileManager.pathScanRecursive()") {
                let scanResult = FileManager.pathScanRecursive(
                    "/Volumes/dev/xcode/syntropy/test/by_structure"
                )
                dump(scanResult)
            }

            Button("FileManager.pathToSafePath()") {
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder/") )
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder.extension/") )
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension") )
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file.txt") )
            }

        }
    }

}
