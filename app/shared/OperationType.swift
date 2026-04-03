
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

enum OperationType {

    case compres // (paths: [String])
    case extract // (paths: [String])

    init?(incoming appUrl: URL) {
        if      (appUrl.isCompresURL) { self = .compres }
        else if (appUrl.isExtractURL) { self = .extract }
        else { return nil }
    }

}
