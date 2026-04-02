
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Cocoa
import FinderSync

let FINDER_EXT_MENU_TITLE = "Syntropy Archiver"

enum ContextType {

    case compress
    case extract
    case both
    case notSupported

    init(_ urls: [URL]) {
        var objectTypesStatistics: [URL.ObjectType: UInt] = [:]
        for url in urls {
            objectTypesStatistics[
                url.objectType, default: 0
            ] += 1
        }
        switch (
            objectTypesStatistics[.archiveFile   , default: 0].fixBounds(max: 2),
            objectTypesStatistics[.nonArchiveFile, default: 0].fixBounds(max: 2),
            objectTypesStatistics[.dirrectory    , default: 0].fixBounds(max: 2),
        ) {
            case (0, 0, 1): self = .compress; Logger.customLog("ContextType: ___ + ___ + ___ + ___ + dir + ___")
            case (0, 0, 2): self = .compress; Logger.customLog("ContextType: ___ + ___ + ___ + ___ + dir + dir")
            case (0, 1, 0): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + ___ + ___ + ___")
            case (0, 1, 1): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + ___ + dir + ___")
            case (0, 1, 2): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + ___ + dir + dir")
            case (0, 2, 0): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + txt + ___ + ___")
            case (0, 2, 1): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + txt + dir + ___")
            case (0, 2, 2): self = .compress; Logger.customLog("ContextType: ___ + ___ + txt + txt + dir + dir")
            case (1, 0, 0): self = .extract ; Logger.customLog("ContextType: zip + ___ + ___ + ___ + ___ + ___")
            case (1, 0, 1): self = .compress; Logger.customLog("ContextType: zip + ___ + ___ + ___ + dir + ___")
            case (1, 0, 2): self = .compress; Logger.customLog("ContextType: zip + ___ + ___ + ___ + dir + dir")
            case (1, 1, 0): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + ___ + ___ + ___")
            case (1, 1, 1): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + ___ + dir + ___")
            case (1, 1, 2): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + ___ + dir + dir")
            case (1, 2, 0): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + txt + ___ + ___")
            case (1, 2, 1): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + txt + dir + ___")
            case (1, 2, 2): self = .compress; Logger.customLog("ContextType: zip + ___ + txt + txt + dir + dir")
            case (2, 0, 0): self = .both    ; Logger.customLog("ContextType: zip + zip + ___ + ___ + ___ + ___")
            case (2, 0, 1): self = .compress; Logger.customLog("ContextType: zip + zip + ___ + ___ + dir + ___")
            case (2, 0, 2): self = .compress; Logger.customLog("ContextType: zip + zip + ___ + ___ + dir + dir")
            case (2, 1, 0): self = .compress; Logger.customLog("ContextType: zip + zip + txt + ___ + ___ + ___")
            case (2, 1, 1): self = .compress; Logger.customLog("ContextType: zip + zip + txt + ___ + dir + ___")
            case (2, 1, 2): self = .compress; Logger.customLog("ContextType: zip + zip + txt + ___ + dir + dir")
            case (2, 2, 0): self = .compress; Logger.customLog("ContextType: zip + zip + txt + txt + ___ + ___")
            case (2, 2, 1): self = .compress; Logger.customLog("ContextType: zip + zip + txt + txt + dir + ___")
            case (2, 2, 2): self = .compress; Logger.customLog("ContextType: zip + zip + txt + txt + dir + dir")
            default: self = .notSupported
        }
    }

}

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
        switch menuKind {
            case .contextualMenuForItems, .contextualMenuForContainer:
                let contextType: ContextType = .init(self.selectedURLs)
                if (contextType == .compress) { menu.addItem(self.menuItemForCompress) }
                if (contextType == .extract ) { menu.addItem(self.menuItemForExtract) }
                if (contextType == .both    ) { menu.addItem(self.menuItemForCompress); menu.addItem(self.menuItemForExtract) }
            default: break
        }
        return menu
    }

    @objc func onContextMenu(_ menuItem: NSMenuItem) {

        let combinedURLs = self.selectedURLs.reduce(into: [String]()) { result, url in
            result.append(url.path.trimPrefix(URL.PREFIX_FILE))
        }.joined(separator: "+")

        if (menuItem.tag == 0) {
            if let resultURL = URL(string: URL.PREFIX_THIS_APP_COMPRESS + combinedURLs) {
                NSWorkspace.shared.open(
                    resultURL
                )
            }
        }
        if (menuItem.tag == 1) {
            if let resultURL = URL(string: URL.PREFIX_THIS_APP_EXTRACT + combinedURLs) {
                NSWorkspace.shared.open(
                    resultURL
                )
            }
        }
    }

}
