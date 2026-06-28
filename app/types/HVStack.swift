
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct HVStack<Content: View>: View {

    private let axis: Axis
    private let spacing: CGFloat
    private let content: () -> Content

    init(
        axis: Axis,
        spacing: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        Group {
            switch self.axis {
                case .horizontal: HStack(spacing: self.spacing) { content() }
                case .vertical  : VStack(spacing: self.spacing) { content() }
            }
        }
    }

}
