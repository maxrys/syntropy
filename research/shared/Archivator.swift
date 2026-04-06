
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

final class Archivator {

    static public func pathScanRecursuve(_ path: String) -> [String] {
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

    static public func pathToSafePath(_ path: String) -> String {
        if FileManager.default.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            let parentPath      = url.parentPath
            let objectName      = url.pathName
            let objectExtension = url.pathExtension
            let timeMark        = Date().ISO8601Mono
            if (objectExtension.isEmpty)
                 { return "\(parentPath)/\(objectName)-\(timeMark)" }
            else { return "\(parentPath)/\(objectName)-\(timeMark).\(objectExtension)" }
        } else {
            return path
        }
    }

    static public func pathsTrimSharedPrefix(_ paths: [String]) -> [String] {
        var result: [String] = []
        return result
    }

    static public func compress(from sourcePaths: [String], to destinationPath: String) {
        do {
            let archiveURL = URL(fileURLWithPath: destinationPath)
            let archive = try Archive(
                url: archiveURL,
                accessMode: .create
            )
            for sourcePath in sourcePaths {
                let sourceURL = URL(fileURLWithPath: sourcePath)
                try archive.addEntry(
                    with: sourceURL.path,
                    fileURL: sourceURL
                )
            }
        } catch {
            Logger.customLog("\(error.localizedDescription)")
        }
    }

}
