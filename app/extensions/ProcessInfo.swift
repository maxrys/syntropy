
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension ProcessInfo {

    static var isPreview: Bool {
        if Self.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return true }
        if Self.processInfo.environment["XCODE_RUNNING_FOR_PREVIEW" ] == "1" { return true }
        return false
    }

}
