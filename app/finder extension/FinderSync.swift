
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import FinderSync

let FINDER_EXT_MENU_TITLE = "Syntropy Archiver"

class FinderSync: FIFinderSync {

    var selectedURLs: [URL] {
        if let urls = FIFinderSyncController.default().selectedItemURLs() {
            return urls
        }
        return []
    }

    var menuItemForCompress: NSMenuItem {
        let menuItem = NSMenuItem()
            menuItem.title = NSLocalizedString("Compress Using Syntropy", comment: "")
            menuItem.image = NSImage(named: "icon-compression")!
            menuItem.action = #selector(onContextMenu(_:))
            menuItem.tag = 0
            menuItem.target = self
        return menuItem
    }

    var menuItemForExtract: NSMenuItem {
        let menuItem = NSMenuItem()
            menuItem.title = NSLocalizedString("Extract Using Syntropy", comment: "")
            menuItem.image = NSImage(named: "icon-extraction")!
            menuItem.action = #selector(onContextMenu(_:))
            menuItem.tag = 1
            menuItem.target = self
        return menuItem
    }

    override init() {
        super.init()
        self.updateWatchedVolumes()
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.updateWatchedVolumes), name: NSWorkspace.didMountNotification  , object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.updateWatchedVolumes), name: NSWorkspace.didUnmountNotification, object: nil)
        Logger.customLog("FinderSync Extension launched from: \(Bundle.main.bundlePath)")
    }

    @objc func updateWatchedVolumes() {
        var urls = Set<URL>()
        urls.insert(URL(fileURLWithPath: "/"))
        if let volumes = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: []) {
            for volume in volumes {
                urls.insert(volume)
            }
        }
        FIFinderSyncController.default().directoryURLs = urls
        Logger.customLog("FinderSync Extension Update volumes: \(urls.map { $0.path })")
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let selectedURLs = self.selectedURLs
        guard !selectedURLs.isEmpty else {
            return NSMenu()
        }
        let menu = NSMenu(title: FINDER_EXT_MENU_TITLE)
        if (menuKind == .contextualMenuForItems || menuKind == .contextualMenuForContainer) {
            switch ContextType(finder: self.selectedURLs) {
                case .notSupported: break
                case .compress: menu.addItem(self.menuItemForCompress)
                case .extract : menu.addItem(self.menuItemForExtract)
                case .both    : menu.addItem(self.menuItemForCompress)
                                menu.addItem(self.menuItemForExtract)
            }
        }
        return menu
    }

    @objc func onContextMenu(_ menuItem: NSMenuItem) {

        let combinedPaths = self.selectedURLs.reduce(into: [String]()) { result, url in
            result.append(url.path)
        }.joined(separator: "+")

        if (menuItem.tag == 0) {
            if let resultURL = URL(string: URL.SCHEME_FOR_COMPRESS + "://" + combinedPaths) {
                NSWorkspace.shared.open(
                    resultURL
                )
            }
        }
        if (menuItem.tag == 1) {
            if let resultURL = URL(string: URL.SCHEME_FOR_EXTRACT + "://" + combinedPaths) {
                NSWorkspace.shared.open(
                    resultURL
                )
            }
        }
    }

}
