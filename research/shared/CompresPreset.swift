
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation
import ZIPFoundation

struct CompresPreset {

    enum DateMode {
        case original
        case current
        case custom(value: Date)
    }

    let isRelativePath: Bool
    let isIncludeEmptyDirs: Bool
    let isFollowLinks: Bool
    let compression: CompressionMethod
    let throttling: Double?
    let excludePattern: String?
    let date: DateMode

}
