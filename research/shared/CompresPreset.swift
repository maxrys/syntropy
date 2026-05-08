
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation
import ZIPFoundation

struct CompresPreset: Equatable {

    let isRelativePath: Bool
    let isIncludeEmptyDirs: Bool
    let isFollowLinks: Bool
    let compression: CompressionMethod
    let updatedMode: DateMode.Mode
    let throttling: Double?
    let excludePattern: String?

}
