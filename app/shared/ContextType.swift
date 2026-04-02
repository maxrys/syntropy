
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

enum ContextType {

    case compress
    case extract
    case both
    case notSupported

    init(incoming url: URL) {
        if (url.isCompressURL)     { self = .compress }
        else if (url.isExtractURL) { self = .extract }
        else                       { self = .notSupported }
    }

    init(_ urls: [URL]) {
        var objectTypesStatistics: [URL.ObjectType: UInt] = [:]
        for url in urls {
            objectTypesStatistics[
                url.objectType, default: 0
            ] += 1
        }
        switch (
            objectTypesStatistics[.archiveFile   , default: 0].fixBounds(max: 2),
            objectTypesStatistics[.nonArchiveFile, default: 0].fixBounds(max: 2),
            objectTypesStatistics[.dirrectory    , default: 0].fixBounds(max: 2),
        ) {
            case (0, 0, 1): self = .compress; Logger.customLog("ContextType: ___ + ___ + ___ + ___ + dir + ___")
            case (0, 0, 2): self = .compress; Logger.customLog("ContextType: ___ + ___ + ___ + ___ + dir + dir")
            case (0, 1, 0): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + ___ + ___ + ___")
            case (0, 1, 1): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + ___ + dir + ___")
            case (0, 1, 2): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + ___ + dir + dir")
            case (0, 2, 0): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + txt + ___ + ___")
            case (0, 2, 1): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + txt + dir + ___")
            case (0, 2, 2): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + txt + dir + dir")
            case (1, 0, 0): self = .extract ; Logger.customLog("ContextType: zip + ___ + ___ + ___ + ___ + ___")
            case (1, 0, 1): self = .compress; Logger.customLog("ContextType: zip + ___ + ___ + ___ + dir + ___")
            case (1, 0, 2): self = .compress; Logger.customLog("ContextType: zip + ___ + ___ + ___ + dir + dir")
            case (1, 1, 0): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + ___ + ___ + ___")
            case (1, 1, 1): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + ___ + dir + ___")
            case (1, 1, 2): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + ___ + dir + dir")
            case (1, 2, 0): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + txt + ___ + ___")
            case (1, 2, 1): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + txt + dir + ___")
            case (1, 2, 2): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + txt + dir + dir")
            case (2, 0, 0): self = .both    ; Logger.customLog("ContextType: zip + zip + ___ + ___ + ___ + ___")
            case (2, 0, 1): self = .compress; Logger.customLog("ContextType: zip + zip + ___ + ___ + dir + ___")
            case (2, 0, 2): self = .compress; Logger.customLog("ContextType: zip + zip + ___ + ___ + dir + dir")
            case (2, 1, 0): self = .compress; Logger.customLog("ContextType: zip + zip + txt + ___ + ___ + ___")
            case (2, 1, 1): self = .compress; Logger.customLog("ContextType: zip + zip + txt + ___ + dir + ___")
            case (2, 1, 2): self = .compress; Logger.customLog("ContextType: zip + zip + txt + ___ + dir + dir")
            case (2, 2, 0): self = .compress; Logger.customLog("ContextType: zip + zip + txt + txt + ___ + ___")
            case (2, 2, 1): self = .compress; Logger.customLog("ContextType: zip + zip + txt + txt + dir + ___")
            case (2, 2, 2): self = .compress; Logger.customLog("ContextType: zip + zip + txt + txt + dir + dir")
            default: self = .notSupported
        }
    }

}
