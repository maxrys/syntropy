
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    static let PREFIX_THIS_APP_COMPRESS = "syntropyArchiverCompress://"
    static let PREFIX_THIS_APP_EXTRACT = "syntropyArchiverExtract://"
    static let PREFIX_FILE = "file://"
    static let SUFFIX_DIRRECTORY = "/"

    public func pathTrimmed(isTrimSuffix: Bool = true) -> String {
        var result = self.path
            result = result.trimPrefix(URL.PREFIX_THIS_APP_COMPRESS)
            result = result.trimPrefix(URL.PREFIX_THIS_APP_EXTRACT)
            result = result.trimPrefix(URL.PREFIX_FILE)
        if (isTrimSuffix) { result = result.trimSuffix(URL.SUFFIX_DIRRECTORY) }
        return result
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
