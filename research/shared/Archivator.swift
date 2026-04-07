
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

final class Archivator {

    static public func compres(
        from sourcePaths: [String],
        to destinationPath: String,
        isTrimPrefix: Bool = true
    ) {
        do {
            let archiveURL = URL(fileURLWithPath: destinationPath)
            let archive = try Archive(
                url: archiveURL,
                accessMode: .create
            )
            var pathSharedPrefix: String? = nil
            if (isTrimPrefix) {
                pathSharedPrefix = FileManager.pathsSharedPrefix(
                    sourcePaths
                )
            }
            for sourcePath in sourcePaths {
                let sourceURL = URL(fileURLWithPath: sourcePath)
                var pathInArchive = sourceURL.path
                if let pathSharedPrefix {
                    pathInArchive = pathInArchive.trimPrefix(pathSharedPrefix)
                }
                try archive.addEntry(
                    with: pathInArchive,
                    fileURL: sourceURL
                )
            }
        } catch {
            Logger.customLog("\(error.localizedDescription)")
        }
    }

}
