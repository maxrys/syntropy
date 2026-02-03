
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

let URL_PREFIX_FILE = "file://"
let URL_PREFIX_THIS_APP = "syntropyArchiver://"

let FINDER_EXT_DIRECTORY_URLS: Set<URL> = [
    URL(fileURLWithPath: "/")
]

let FINDER_EXT_MENU_TITLE = "Syntropy Archiver"
let FINDER_EXT_MENU_ITEMS = [
    (
        eventName: "SyntropyFinderContextMenuCompress",
        titleLocalized: NSLocalizedString("Compress Using Syntropy", comment: ""),
        iconName: "1.square"
    ),
    (
        eventName: "SyntropyFinderContextMenuExtract",
        titleLocalized: NSLocalizedString("Extract Using Syntropy", comment: ""),
        iconName: "2.square"
    )
]
