
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_Button: ToolbarCustom_item_Protocol {

    @Environment(\.colorScheme) private var colorScheme

    @State private var isHovering = false

    let title: String
    let icon: Image
    let keyboardShortcut: KeyboardShortcut?
    let action: () -> Void

    init(
        title: String,
        icon: Image,
        keyboardShortcut: KeyboardShortcut? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.keyboardShortcut = keyboardShortcut
        self.action = action
    }

    public var body: some View {
        VStack(spacing: ToolbarCustom.BUTTON_AND_TITLE_SPACING) {
            self.buttonView
                .keyboardShortcut(self.keyboardShortcut)
            self.titleView
                .frame(maxWidth: 35)
        }
    }

    @ViewBuilder private var buttonView: some View {
        Button {
            self.action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: ToolbarCustom.BUTTON_CORNER_RADIUS)
                    .stroke(
                        self.colorScheme == .dark ?
                            ToolbarCustom.ICON_BORDER_COLOR_DARK :
                            ToolbarCustom.ICON_BORDER_COLOR,
                        style: StrokeStyle(lineWidth: 1)
                    )
                self.icon
                    .font(.system(size: ToolbarCustom.ICON_FONT_SIZE))
                    .foregroundStyle(
                        self.colorScheme == .dark ?
                            ToolbarCustom.ICON_COLOR_DARK :
                            ToolbarCustom.ICON_COLOR
                    )
            }
            .frame(
                width : ToolbarCustom.BUTTON_WIDTH,
                height: ToolbarCustom.BUTTON_HEIGHT
            )
            .contentShape(RoundedRectangle(
                cornerRadius: ToolbarCustom.BUTTON_CORNER_RADIUS)
            )
        }
        .buttonStyle(.plain)
        .pointerStyleLinkPolyfill()
        .onHover { isHovering in
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isHovering = isHovering
            }
        }
    }

    @ViewBuilder private var titleView: some View {
        Text(self.title)
            .lineLimit(1)
            .font(.system(size: ToolbarCustom.TITLE_FONT_SIZE))
            .foregroundStyle(
                self.colorScheme == .dark ?
                    ToolbarCustom.TITLE_COLOR_DARK :
                    ToolbarCustom.TITLE_COLOR
            )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ToolbarCustom_Preview.previews
}
