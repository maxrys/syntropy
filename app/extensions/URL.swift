
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    static public let SCHEME_FOR_COMPRESS = "syntropyArchiverCompress"
    static public let SCHEME_FOR_EXTRACT = "syntropyArchiverExtract"

    public var isCompressURL: Bool {
        self.scheme == Self.SCHEME_FOR_COMPRESS
    }

    public var isExtractURL: Bool {
        self.scheme == Self.SCHEME_FOR_EXTRACT
    }

    public enum ObjectType {
        case archiveFile
        case nonArchiveFile
        case dirrectory
        case notSupported
    }

    public var objectType: ObjectType {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: self.path) else {
            return .notSupported
        }
        if let attribute = attributes[.type] as? FileAttributeType {
            switch attribute {
                case .typeDirectory: return .dirrectory
                case .typeRegular  : return FORMATS.contains(self.pathExtension) ? .archiveFile : .nonArchiveFile
                default: return .notSupported
            }
        } else {
            return .notSupported
        }
    }

}
