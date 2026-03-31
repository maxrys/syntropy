
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension URL {

    static let PREFIX_THIS_APP = "syntropyArchiver://"
    static let PREFIX_FILE = "file://"
    static let SUFFIX_DIRRECTORY = "/"

    public func trimmed(isTrimSuffix: Bool = true) -> String {
        if (isTrimSuffix) { return self.absoluteString.trimPrefix(URL.PREFIX_THIS_APP).trimPrefix(URL.PREFIX_FILE).trimSuffix(URL.SUFFIX_DIRRECTORY) }
        else              { return self.absoluteString.trimPrefix(URL.PREFIX_THIS_APP).trimPrefix(URL.PREFIX_FILE) }
    }

}
