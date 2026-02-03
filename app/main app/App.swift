
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { return true }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { return true }
}

@main struct ThisApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) private var openWindow

    public var body: some Scene {

        WindowGroup {
            VStack(spacing: 0) {
                Toolbar(padding: .init(top: 12, leading: 80, bottom: 10, trailing: 20))
                MainScene()
                    .frame(minWidth: 100      , minHeight: 100)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.ignoresSafeArea()
        }
        .windowStyle(.hiddenTitleBar)
        .restorationBehavior(.disabled)
        .environment(\.layoutDirection, .leftToRight)
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Settings") {
                    openWindow(id: "settings")
                }
            }
        }

        Window("Settings", id: "settings") {
            Settings()
                .frame(
                    maxWidth : .infinity,
                    maxHeight: .infinity
                )
        }

    }

}
