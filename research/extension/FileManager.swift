
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension FileManager {

    public struct ScanRecursiveResult {
        public var directories: [String] = []
        public var files      : [String] = []
        public var links      : [String] = []
        public var emptyDirectories: [String] {
            self.directories.filter { checkingPath in
                let hasChild = self.files      .contains { filePath      in                                  filePath     .hasPrefix(checkingPath) } ||
                               self.links      .contains { linkPath      in                                  linkPath     .hasPrefix(checkingPath) } ||
                               self.directories.contains { directoryPath in directoryPath != checkingPath && directoryPath.hasPrefix(checkingPath) }
                return !hasChild
            }
        }
    }

    static public func pathScanRecursive(_ path: String) -> ScanRecursiveResult {
        var result = ScanRecursiveResult()
        let enumerator = Self.default.enumerator(
            at: URL(fileURLWithPath: path),
            includingPropertiesForKeys: nil
        )
        if let enumerator {
            for case let url as URL in enumerator {
                if let attributes = try? Self.default.attributesOfItem(atPath: url.path) {
                    if let type = attributes[.type] as? FileAttributeType {
                        switch type {
                            case .typeDirectory   : result.directories.append(url.path.addSuffixIfMissing("/"))
                            case .typeRegular     : result.files      .append(url.path)
                            case .typeSymbolicLink: result.links      .append(url.path)
                            default: break
                        }
                    }
                }
            }
        }
        return result
    }

    static public func pathToSafePath(_ path: String) -> String {
        if Self.default.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            let parentPath      = url.parentPath
            let objectName      = url.pathName
            let objectExtension = url.pathExtension
            let suffux          = path.hasSuffix("/") ? "/" : ""
            let timeMark        = Date().ISO8601Mono
            if (objectExtension.isEmpty)
                 { return "\(parentPath)/\(objectName)-\(timeMark)\(suffux)" }
            else { return "\(parentPath)/\(objectName)-\(timeMark).\(objectExtension)\(suffux)" }
        } else {
            return path
        }
    }

    static public func pathsTrimSharedPrefix(_ paths: [String]) -> [String] {
        if let pathsSharedPrefix = Self.pathsSharedPrefix(paths)
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

}
