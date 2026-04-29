
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

final class CompresSource {

    struct ItemInfo {
        let path: String
        let basePath: String
    }

    public private(set) var files           : [ItemInfo] = []
    public private(set) var links           : [ItemInfo] = []
    public private(set) var directories     : [ItemInfo] = []
    public private(set) var emptyDirectories: [ItemInfo] = []

    func addSource(path: String) -> Bool {
        switch URL(fileURLWithPath: path).objectType {
            case .none: return false
            case .link: return false
            case .file:
                self.files.append(ItemInfo(
                    path: path,
                    basePath: URL(fileURLWithPath: path).parentPath
                ))
                return true
            case .directory:
                if let scanData = FileManager.pathScanRecursive(path) {
                    scanData.files           .forEach { foundPath in self.files           .append(ItemInfo(path: foundPath, basePath: path))}
                    scanData.links           .forEach { foundPath in self.links           .append(ItemInfo(path: foundPath, basePath: path))}
                    scanData.directories     .forEach { foundPath in self.directories     .append(ItemInfo(path: foundPath, basePath: path))}
                    scanData.emptyDirectories.forEach { foundPath in self.emptyDirectories.append(ItemInfo(path: foundPath, basePath: path))}
                    return true
                } else {
                    return false
                }
        }
    }

}
