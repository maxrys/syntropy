
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    var pathName: String {
        var url = self
        url.deletePathExtension()
        return url.lastPathComponent
    }

    var parentPath: String {
        var url = self
        url.deleteLastPathComponent()
        return url.path
    }

}
