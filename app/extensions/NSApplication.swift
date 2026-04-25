
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension NSApplication {

    static var isXCodePreview: Bool {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return true }
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEW" ] == "1" { return true }
        return false
    }

    static func show() { NSApp.activate(ignoringOtherApps: true) }
    static func showAppsDock() { Self.shared.setActivationPolicy(.regular  ) }
    static func hideAppsDock() { Self.shared.setActivationPolicy(.accessory) }

}
