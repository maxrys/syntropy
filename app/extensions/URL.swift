
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    static public let SCHEME_FOR_PROCESS = "syntropyArchiver"

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
        case fileArchive
        case fileNonArchive
        case dirrectory
        case notSupported
    }

    public var objectType: ObjectType {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: self.path) else {
            return .notSupported
        }
        if let type = attributes[.type] as? FileAttributeType {
            switch type {
                case .typeRegular:
                    if (FORMATS.contains(self.pathExtension))
                         { return .fileArchive }
                    else { return .fileNonArchive }
                case .typeDirectory: return .dirrectory
                default: return .notSupported
            }
        } else {
            return .notSupported
        }
    }

}
