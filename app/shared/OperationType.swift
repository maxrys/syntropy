
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

enum OperationType {

    case compres(paths: [String])
    case extract(paths: [String])

    init?(_ appUrl: URL) {
        if      (appUrl.isCompresURL) { self = .compres(paths: appUrl.path.components(separatedBy: "+")) }
        else if (appUrl.isExtractURL) { self = .extract(paths: appUrl.path.components(separatedBy: "+")) }
        else { return nil }
    }

}
