
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension FileManager {

    public class ScanRecursiveResult {
        public var files           : [String] = []
        public var links           : [String] = []
        public var directories     : [String] = []
        public var emptyDirectories: [String] = []
        public var isEmpty: Bool {
            self.files.isEmpty &&
            self.links.isEmpty &&
            self.directories.isEmpty &&
            self.emptyDirectories.isEmpty
        }
    }

    static public func pathScanRecursive(_ basePath: String) -> ScanRecursiveResult? {
        guard case .directory = URL(fileURLWithPath: basePath).objectType else {
            return nil
        }
        let result = ScanRecursiveResult()
        func scanDirectory(_ path: String) -> Void {
            if let urls = try? Self.default.contentsOfDirectory(at: URL(fileURLWithPath: path), includingPropertiesForKeys: nil) {
                if (!urls.isEmpty) {
                    for url in urls {
                        switch url.objectType {
                            case .none: continue
                            case .file: result.files.append(url.path)
                            case .link: result.links.append(url.path)
                            case .directory:
                                let directoryPath = url.path.addSuffixIfMissing("/")
                                result.directories.append(directoryPath)
                                scanDirectory(directoryPath)
                        }
                    }
                } else {
                    result.emptyDirectories.append(
                        path.addSuffixIfMissing("/")
                    )
                }
            }
        }
        scanDirectory(basePath)
        if (result.isEmpty) { return nil }
        else { return result }
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

 // static public func pathsTrimSharedPrefix(_ paths: [String]) -> [String] {
 //     if let pathsSharedPrefix = Self.pathsSharedPrefix(paths)
 //          { return paths.map { path in path.trimPrefix(pathsSharedPrefix) } }
 //     else { return paths }
 // }

 // static public func pathsSharedPrefix(_ paths: [String]) -> String? {
 //     if let longestString = paths.max(by: { (lhs, rhs) in lhs.count < rhs.count }) {
 //         var parts = longestString.split(separator: "/")
 //         while parts.count > 1 {
 //             parts = parts.dropLast()
 //             let prefix = "/" + parts.joined(separator: "/") + "/"
 //             if (paths.allSatisfy { path in path.hasPrefix(prefix) }) {
 //                 return prefix
 //             }
 //         }
 //     }
 //     return nil
 // }

}
