
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension FileManager {

    public struct ScanRecursiveItem {
        let absolute: String
        let relative: String
        let date: URL.ObjectDate?
    }

    public class ScanRecursiveResult {
        public var files           : [ScanRecursiveItem] = []
        public var links           : [ScanRecursiveItem] = []
        public var directories     : [ScanRecursiveItem] = []
        public var emptyDirectories: [ScanRecursiveItem] = []
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
                        let pathAbsolute = url.path
                        let pathRelative = pathAbsolute.trimPrefix(basePath)
                        switch url.objectType {
                            case .file: result.files.append(ScanRecursiveItem(absolute: pathAbsolute, relative: pathRelative, date: url.objectDate))
                            case .link: result.links.append(ScanRecursiveItem(absolute: pathAbsolute, relative: pathRelative, date: url.objectDate))
                            case .directory:
                                result.directories.append(ScanRecursiveItem(
                                    absolute: pathAbsolute.addSuffixIfMissing("/"),
                                    relative: pathRelative.addSuffixIfMissing("/"), date: url.objectDate))
                                scanDirectory(pathAbsolute.addSuffixIfMissing("/"))
                            case .none: continue
                        }
                    }
                } else {
                    let pathAbsolute = path.addSuffixIfMissing("/")
                    let pathRelative = pathAbsolute.trimPrefix(basePath)
                    let date = URL(fileURLWithPath: pathAbsolute).objectDate
                    result.emptyDirectories.append(ScanRecursiveItem(absolute: pathAbsolute, relative: pathRelative, date: date))
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

}
