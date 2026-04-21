
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct ProgressCustom: View {

    @Binding private var value: Double

    init(value: Binding<Double>) {
        self._value = value
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
    struct ViewWithState: View {
        @State private var progress: Double = 0.0
        public var body: some View {
            VStack(spacing: 5) {
                ProgressCustom(value: self.$progress)
                ProgressCustom(value: .constant(0.0))
                ProgressCustom(value: .constant(0.1))
                ProgressCustom(value: .constant(0.2))
                ProgressCustom(value: .constant(0.3))
                ProgressCustom(value: .constant(0.4))
                ProgressCustom(value: .constant(0.5))
                ProgressCustom(value: .constant(0.6))
                ProgressCustom(value: .constant(0.7))
                ProgressCustom(value: .constant(0.8))
                ProgressCustom(value: .constant(0.9))
                ProgressCustom(value: .constant(1.0))
                ProgressCustom(value: .constant(1.1))
            }.padding(20).frame(width: 200)
        }
    }
    static public var previews: some View {
        ViewWithState()
    }
}

