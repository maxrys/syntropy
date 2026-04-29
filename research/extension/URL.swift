
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    public typealias ObjectDate = (
        created: Date,
        updated: Date
    )

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

    public enum ObjectType {
        case file(isArchive: Bool)
        case link
        case directory
    }

    public var objectType: ObjectType? {
        if let attributes = try? self.resourceValues(forKeys: [.isRegularFileKey, .isDirectoryKey, .isSymbolicLinkKey]) {
            if (attributes.isRegularFile  ?? false) { return .file(isArchive: FORMATS.contains(self.pathExtension)) }
            if (attributes.isSymbolicLink ?? false) { return .link }
            if (attributes.isDirectory    ?? false) { return .directory }
        }
        return nil
    }

    public var objectDate: ObjectDate? {
        if let attributes = try? self.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey]) {
            if let created = attributes.creationDate,
               let updated = attributes.contentModificationDate {
                return (created, updated)
            }
        }
        return nil
    }

}
