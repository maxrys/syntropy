
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

enum FinderContextObjectType {
    case fileArchive
    case fileNonArchive
    case directory
}

enum FinderContextType {

    case compres
    case extract
    case both

    init?(_ urls: [URL]) {
        var objectTypesStatistics: [FinderContextObjectType: UInt] = [:]
        for url in urls {
            let type = url.objectType
            if case .file(let isArchive) = type, isArchive == true { objectTypesStatistics[.fileArchive   , default: 0] += 1 }
            if case .file(let isArchive) = type, isArchive != true { objectTypesStatistics[.fileNonArchive, default: 0] += 1 }
            if case .directory = type                              { objectTypesStatistics[.directory     , default: 0] += 1 }
        }
        switch (
            objectTypesStatistics[.fileArchive   , default: 0].fixBounds(max: 2),
            objectTypesStatistics[.fileNonArchive, default: 0].fixBounds(max: 2),
            objectTypesStatistics[.directory     , default: 0].fixBounds(max: 2),
        ) {
            case (0, 0, 1): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + ___ + ___ + dir + ___")
            case (0, 0, 2): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + ___ + ___ + dir + dir")
            case (0, 1, 0): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + txt + ___ + ___ + ___")
            case (0, 1, 1): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + txt + ___ + dir + ___")
            case (0, 1, 2): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + txt + ___ + dir + dir")
            case (0, 2, 0): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + txt + txt + ___ + ___")
            case (0, 2, 1): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + txt + txt + dir + ___")
            case (0, 2, 2): self = .compres; Logger.customLog("FinderContextType: ___ + ___ + txt + txt + dir + dir")
            case (1, 0, 0): self = .extract; Logger.customLog("FinderContextType: zip + ___ + ___ + ___ + ___ + ___")
            case (1, 0, 1): self = .compres; Logger.customLog("FinderContextType: zip + ___ + ___ + ___ + dir + ___")
            case (1, 0, 2): self = .compres; Logger.customLog("FinderContextType: zip + ___ + ___ + ___ + dir + dir")
            case (1, 1, 0): self = .compres; Logger.customLog("FinderContextType: zip + ___ + txt + ___ + ___ + ___")
            case (1, 1, 1): self = .compres; Logger.customLog("FinderContextType: zip + ___ + txt + ___ + dir + ___")
            case (1, 1, 2): self = .compres; Logger.customLog("FinderContextType: zip + ___ + txt + ___ + dir + dir")
            case (1, 2, 0): self = .compres; Logger.customLog("FinderContextType: zip + ___ + txt + txt + ___ + ___")
            case (1, 2, 1): self = .compres; Logger.customLog("FinderContextType: zip + ___ + txt + txt + dir + ___")
            case (1, 2, 2): self = .compres; Logger.customLog("FinderContextType: zip + ___ + txt + txt + dir + dir")
            case (2, 0, 0): self = .both   ; Logger.customLog("FinderContextType: zip + zip + ___ + ___ + ___ + ___")
            case (2, 0, 1): self = .compres; Logger.customLog("FinderContextType: zip + zip + ___ + ___ + dir + ___")
            case (2, 0, 2): self = .compres; Logger.customLog("FinderContextType: zip + zip + ___ + ___ + dir + dir")
            case (2, 1, 0): self = .compres; Logger.customLog("FinderContextType: zip + zip + txt + ___ + ___ + ___")
            case (2, 1, 1): self = .compres; Logger.customLog("FinderContextType: zip + zip + txt + ___ + dir + ___")
            case (2, 1, 2): self = .compres; Logger.customLog("FinderContextType: zip + zip + txt + ___ + dir + dir")
            case (2, 2, 0): self = .compres; Logger.customLog("FinderContextType: zip + zip + txt + txt + ___ + ___")
            case (2, 2, 1): self = .compres; Logger.customLog("FinderContextType: zip + zip + txt + txt + dir + ___")
            case (2, 2, 2): self = .compres; Logger.customLog("FinderContextType: zip + zip + txt + txt + dir + dir")
            default: return nil
        }
    }

}
