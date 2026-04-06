
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
        if let pathsSharedPrefix = self.pathsSharedPrefix(paths)
             { return paths.map { path in path.trimPrefix(pathsSharedPrefix) } }
        else { return paths }
    }

    static public func pathsSharedPrefix(_ paths: [String]) -> String? {
        if let longestString = paths.max(by: { (lhs, rhs) in lhs.count < rhs.count }) {
            var parts = longestString.split(separator: "/")
            while parts.count > 1 {
                parts = parts.dropLast()
                let prefix = "/" + parts.joined(separator: "/") + "/"
                if (paths.allSatisfy { path in path.hasPrefix(prefix) }) {
                    return prefix
                }
            }
        }
        return nil
    }

    static public func compress(
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
                pathSharedPrefix = self.pathsSharedPrefix(
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
