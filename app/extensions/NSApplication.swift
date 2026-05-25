
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension NSApplication {

    static public var appVersion      : String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
    static public var appBuild        : String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion"           ) as? String }
    static public var appCopyright    : String? { Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright"  ) as? String }
    static public var appNameLocalized: String  { Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName"       ) as? String ?? NSLocalizedString(ProcessInfo.processInfo.processName, comment: "") }

    static var isXCodePreview: Bool {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return true }
        return false
    }

    static func show() { NSApp.activate(ignoringOtherApps: true) }
    static func showAppsDock() { Self.shared.setActivationPolicy(.regular  ) }
    static func hideAppsDock() { Self.shared.setActivationPolicy(.accessory) }

}
