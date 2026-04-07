
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension Double {

    var fractionalPart: Double {
        self - floor(self)
    }

}
