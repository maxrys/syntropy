
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

final class CompresSourceInfo {

    public class DataSet {
        public var files           : [(path: String, basePath: String)] = []
        public var links           : [(path: String, basePath: String)] = []
        public var directories     : [(path: String, basePath: String)] = []
        public var emptyDirectories: [(path: String, basePath: String)] = []
    }

    public private(set) var dataSet = DataSet()

    func addSource(path: String) -> Bool {
        switch URL(fileURLWithPath: path).objectType {
            case .none: return false
            case .link: return false
            case .file:
                self.dataSet.files.append((
                    path: path,
                    basePath: URL(fileURLWithPath: path).parentPath
                ))
                return true
            case .directory:
                if let scanData = FileManager.pathScanRecursive(path) {
                    scanData.files           .forEach { foundPath in self.dataSet.files           .append((path: foundPath, basePath: path))}
                    scanData.links           .forEach { foundPath in self.dataSet.links           .append((path: foundPath, basePath: path))}
                    scanData.directories     .forEach { foundPath in self.dataSet.directories     .append((path: foundPath, basePath: path))}
                    scanData.emptyDirectories.forEach { foundPath in self.dataSet.emptyDirectories.append((path: foundPath, basePath: path))}
                    return true
                } else {
                    return false
                }
        }
    }

}
