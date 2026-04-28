
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    var pathName: String {
        var url = self
        url.deletePathExtension()
        return url.lastPathComponent
    }

    var parentPath: String {
        var url = self
        url.deleteLastPathComponent()
        return url.path
    }

    public enum EntityType {
        case file(isArchive: Bool)
        case link
        case directory
    }

    public var objectType: EntityType? {
        if let attributes = try? self.resourceValues(forKeys: [.isRegularFileKey, .isDirectoryKey, .isSymbolicLinkKey]) {
            if (attributes.isRegularFile  ?? false) { return .file(isArchive: FORMATS.contains(self.pathExtension)) }
            if (attributes.isSymbolicLink ?? false) { return .link }
            if (attributes.isDirectory    ?? false) { return .directory }
        }
        return nil
    }

}
