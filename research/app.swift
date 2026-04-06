
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

                Button("pathToSafePath()") {
                    Logger.customLog( self.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder") )
                    Logger.customLog( self.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder.extension") )
                    Logger.customLog( self.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension") )
                    Logger.customLog( self.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file.txt") )
                }

                Button("pathScanRecursuve()") {
                    dump(
                        self.pathScanRecursuve(
                            "/Volumes/dev/xcode/syntropy/test/by_structure"
                        )
                    )
                }

                Button("compressFile()") {
                    compressFile(
                        from: "/Volumes/dev/xcode/syntropy/test/by_structure/file 1.txt",
                        to: self.pathToSafePath(
                            "/Volumes/dev/xcode/syntropy/test/result/file.zip"
                        )
                    )
                }

            }
        }
    }

    init() {
    }

    func pathScanRecursuve(_ path: String) -> [String] {
        var result: [String] = []
        let enumerator = FileManager.default.enumerator(
            at: URL(fileURLWithPath: path),
            includingPropertiesForKeys: nil
        )
        if let enumerator {
            for case let url as URL in enumerator {
                if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
                    if let type = attributes[.type] as? FileAttributeType {
                        if type == .typeRegular {
                            result.append(url.path)
                        }
                    }
                }
            }
        }
        return result
    }

    func pathToSafePath(_ path: String) -> String {
        if FileManager.default.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            let parentPath      = url.parentPath
            let objectName      = url.pathName
            let objectExtension = url.pathExtension
            let timeMark        = Date.nowPolyfill.ISO8601Mono
            if (objectExtension.isEmpty)
                 { return "\(parentPath)/\(objectName)-\(timeMark)" }
            else { return "\(parentPath)/\(objectName)-\(timeMark).\(objectExtension)" }
        } else {
            return path
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
