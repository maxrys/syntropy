
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ProgressSimple: View {

    @Environment(\.colorScheme) private var colorScheme

    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: self.radius
        )
    }

    private let height: CGFloat
    private let value: Double
    private let radius: Double

    init(value: Double, height: CGFloat = 10, radius: CGFloat = 0) {
        self.value = value
        self.height = height
        self.radius = radius
    }

    var body: some View {
        Color.clear
            .frame(height: self.height)
            .background( self.IndicatorView() )
            .background( self.BackgroundView() )
    }

    @ViewBuilder func IndicatorView() -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width * self.value.fixBounds(max: 1.0)
            self.shape
                .fill(Color.accentColor)
                .frame(width: width)
        }
    }

    @ViewBuilder func BackgroundView() -> some View {
        self.shape
            .fill(self.colorScheme == .dark ?
                Color.black :
                Color.white
            )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct ProgressSimple_Previews: PreviewProvider {
    static public var previews: some View {
        VStack(spacing: 5) {
            ForEach(Array(stride(from: -0.1, through: 1.1, by: 0.1)), id: \.self) { value in
                ProgressSimple(value: value)
            }
        }.padding(20).frame(width: 200)
    }
}

