
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct ProgressCustom: View {

    private var value: Double

    init(value: Double) {
        self.value = value
    }

    var body: some View {
        GeometryReaderPolyfill(isIgnoreHeight: true) { size in
            Color.NS[\.lightGray]
                .frame(maxWidth: .infinity)
                .frame(height: 10)
                .overlayPolyfill(alignment: .leading) {
                    let width = size.width * self.value.fixBounds(
                        min: 0.0,
                        max: 1.0
                    )
                    Color.accentColor
                        .frame(width: width, height: 10)
                }
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct ProgressCustom_Previews: PreviewProvider {
    static public var previews: some View {
        VStack(spacing: 5) {
            ForEach(Array(stride(from: -0.1, through: 1.1, by: 0.1)), id: \.self) { value in
                ProgressCustom(value: value)
            }
        }.padding(20).frame(width: 200)
    }
}

