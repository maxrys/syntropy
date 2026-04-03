
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    static public let SCHEME_FOR_COMPRES = "syntropyArchiverCompres"
    static public let SCHEME_FOR_EXTRACT = "syntropyArchiverExtract"

    public var isCompresURL: Bool { self.scheme == Self.SCHEME_FOR_COMPRES }
    public var isExtractURL: Bool { self.scheme == Self.SCHEME_FOR_EXTRACT }

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
        if let attribute = attributes[.type] as? FileAttributeType {
            switch attribute {
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
