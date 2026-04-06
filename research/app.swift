
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

                Button("path resolve") {
                    Logger.customLog( self.pathResolve("/Volumes/dev/xcode/syntropy/test/by_types/folder") )
                    Logger.customLog( self.pathResolve("/Volumes/dev/xcode/syntropy/test/by_types/folder.extension") )
                    Logger.customLog( self.pathResolve("/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension") )
                    Logger.customLog( self.pathResolve("/Volumes/dev/xcode/syntropy/test/by_types/file.txt") )
                    
                }

                Button("compress file") {
                    compressFile(
                        from: "/Volumes/dev/xcode/syntropy/test/by_structure/file 1.txt",
                        to: self.pathResolve(
                            "/Volumes/dev/xcode/syntropy/test/result/file.zip"
                        )
                    )
                }

            }
        }
    }

    init() {
    }

    func pathResolve(_ destinationPath: String) -> String {
        if FileManager.default.fileExists(atPath: destinationPath) {
            let url = URL(fileURLWithPath: destinationPath)
            let parentPath = url.parentPath
            let objectName = url.pathName
            let objectExtension = url.pathExtension
            let timeMark = Date.nowPolyfill.ISO8601Mono
            if (objectExtension.isEmpty)
                 { return "\(parentPath)/\(objectName)-\(timeMark)" }
            else { return "\(parentPath)/\(objectName)-\(timeMark).\(objectExtension)" }
        } else {
            return destinationPath
        }
    }

    func compressFile(from sourcePath: String, to destinationPath: String) {
        do {
            let archiveURL = URL(fileURLWithPath: destinationPath)
            let archive = try Archive(
                url: archiveURL,
                accessMode: .create
            )
            let sourceURL = URL(fileURLWithPath: sourcePath)
            try archive.addEntry(
                with: sourceURL.lastPathComponent,
                fileURL: sourceURL
            )
        } catch {
            Logger.customLog("\(error.localizedDescription)")
        }
    }

}
