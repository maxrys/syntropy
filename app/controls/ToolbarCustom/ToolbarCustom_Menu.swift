
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_Menu: ToolbarCustom_item_Protocol {

    @Environment(\.colorScheme) private var colorScheme

    @State private var isHovering = false

    let title: String
    let icon: Image
    let keyboardShortcut: KeyboardShortcut?
    let action: (() -> Void)?
    let contents: [any View]

    init(
        title: String,
        icon: Image,
        keyboardShortcut: KeyboardShortcut? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilderArray<View> content: () -> [any View]
    ) {
        self.title = title
        self.icon = icon
        self.keyboardShortcut = keyboardShortcut
        self.action = action
        self.contents = content()
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
        ZStack {
            RoundedRectangle(cornerRadius: ToolbarCustom.BUTTON_CORNER_RADIUS)
                .stroke(
                    self.colorScheme == .dark ?
                        ToolbarCustom.ICON_BORDER_COLOR_DARK :
                        ToolbarCustom.ICON_BORDER_COLOR,
                    style: StrokeStyle(lineWidth: 1)
                )
            HStack(spacing: 0) {
                if let action = self.action {
                    Button {
                        action()
                    } label: {
                        self.icon
                            .font(.system(size: ToolbarCustom.ICON_FONT_SIZE))
                    }
                    .buttonStyle(.plain)
                    .pointerStyleLinkPolyfill()
                } else {
                    self.icon
                        .font(.system(size: ToolbarCustom.ICON_FONT_SIZE))

                }
                Menu("") {
                    ForEach(0 ..< self.contents.count, id: \.self) { index in
                        if let menuItem = self.contents[safe: index] {
                            AnyView(menuItem)
                        }
                    }
                }
                .menuStyle(.borderlessButton)
                .pointerStyleLinkPolyfill()
                .frame(width: 19, height: 20)
                .padding(.horizontal, -2)
            }
            .foregroundStyle(
                self.colorScheme == .dark ?
                    ToolbarCustom.ICON_COLOR_DARK :
                    ToolbarCustom.ICON_COLOR
            )
        }
        .frame(
            width : ToolbarCustom.BUTTON_WIDTH + 21,
            height: ToolbarCustom.BUTTON_HEIGHT
        )
        .contentShape(RoundedRectangle(
            cornerRadius: ToolbarCustom.BUTTON_CORNER_RADIUS)
        )
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
