
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

@main final class App: NSApplicationMultiLaunch, NSWindowDelegate {

    @MainActor static public var appDelegate: App!

    static func main() {
        let app = NSApplication.shared
        Self.appDelegate = App()
        app.delegate = Self.appDelegate
        app.run()
    }

    static public var appVersion      : String? { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String }
    static public var appBundleVersion: String? { Bundle.main.infoDictionary?["CFBundleVersion"           ] as? String }
    static public var appCopyright    : String? { Bundle.main.infoDictionary?["NSHumanReadableCopyright"  ] as? String }

    func applicationSupportsSecureRestorableState       (_    app: NSApplication) -> Bool { true }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

    override func onLaunchViaClickIcon() {
        self.showWindowMain()
    }

    override func onLaunchViaReceivedURLs(urls: [URL]) {
        for url in urls {
            // ...
        }
    }

    func showWindowMain() {
        Logger.customLog("Main Window will show")
        if let windowMain = NSWindow.customWindows[WINDOW_MAIN_ID] {
            windowMain.show()
        } else {
            _ = NSWindow.makeAndShowFromSwiftUIView(
                ID   : WINDOW_MAIN_ID,
                title: WINDOW_MAIN_TITLE,
                isVisible: true,
                size: CGSize(width: 600, height: 300),
                delegate: self,
                view:
                    VStack(spacing: 0) {
                        Toolbar(padding: .init(top: 12, leading: 80, bottom: 10, trailing: 20))
                        MainScene()
                    }
                    .environment(\.layoutDirection, .leftToRight)
                    .frame(
                        minWidth : 505,
                        minHeight: 100
                    ).ignoresSafeArea()
            )
            if let window = NSWindow.get(WINDOW_MAIN_ID) {
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.styleMask.insert(
                    .fullSizeContentView
                )
            }
        }
        NSApplication.showAppsDock()
        NSApp.mainMenu = NSMenu.main
        NSApplication.show() /* menu reactivation */
    }

    @objc func showWindowSettings() {
        Logger.customLog("Settings Window will show")
        if let windowSettings = NSWindow.customWindows[WINDOW_SETTINGS_ID] {
            windowSettings.show()
        } else {
            _ = NSWindow.makeAndShowFromSwiftUIView(
                ID   : WINDOW_SETTINGS_ID,
                title: WINDOW_SETTINGS_TITLE,
                isVisible: true,
                size: CGSize(width: 600, height: 300),
                delegate: self,
                view: Settings()
            )
        }
    }

    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            if let ID = window.ID {
                if (ID == WINDOW_MAIN_ID) {
                    Logger.customLog("Main Window will hide")
                    NSApplication.hideAppsDock()
                    NSApp.mainMenu = nil
                    /* bring the popup window to the foreground */
                    if (!NSWindow.customWindows.isEmpty) {
                        NSApplication.show()
                    }
                }
            }
        }
    }

}
