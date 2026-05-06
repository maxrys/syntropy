
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation
import ZIPFoundation

struct CompresPreset {

    let isRelativePath: Bool
    let isIncludeEmptyDirs: Bool
    let isFollowLinks: Bool
    let compression: CompressionMethod
    let throttling: Double?
    let excludePattern: String?
    let dateMode: DateMode.Mode?
    let dateWithTZ: DatePickerCustom.Value

}
