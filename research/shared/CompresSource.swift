
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

final class CompresSource {

    typealias ItemInfo = FileManager.ScanRecursiveItem

    public private(set) var files           : [ItemInfo] = []
    public private(set) var links           : [ItemInfo] = []
    public private(set) var directories     : [ItemInfo] = []
    public private(set) var emptyDirectories: [ItemInfo] = []

    func addSource(path: String) -> Bool {
        switch URL(fileURLWithPath: path).objectType {
            case .none: return false
            case .link: return false
            case .file:
                let url = URL(fileURLWithPath: path)
                self.files.append(ItemInfo(
                    absolute: path,
                    relative: path.trimPrefix(url.parentPath),
                    date: url.objectDate
                ))
                return true
            case .directory:
                if let scanedItems = FileManager.pathScanRecursive(path) {
                    scanedItems.files           .forEach { itemInfo in self.files           .append(itemInfo) }
                    scanedItems.links           .forEach { itemInfo in self.links           .append(itemInfo) }
                    scanedItems.directories     .forEach { itemInfo in self.directories     .append(itemInfo) }
                    scanedItems.emptyDirectories.forEach { itemInfo in self.emptyDirectories.append(itemInfo) }
                    return true
                } else {
                    return false
                }
        }
    }

}
