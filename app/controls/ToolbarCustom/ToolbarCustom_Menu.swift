
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_Menu: ToolbarCustom_Item_Protocol {

    @Environment(\.colorScheme) private var colorScheme

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
        VStack(spacing: 4) {
            self.ButtonView()
             // .keyboardShortcut(self.keyboardShortcut)
            self.TitleView()
                .frame(maxWidth: 35)
        }
    }

    @ViewBuilder private func ButtonView() -> some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(
                self.colorScheme == .dark ?
                    Color.toolbar.iconBorderDark :
                    Color.toolbar.iconBorder,
                style: StrokeStyle(lineWidth: 1)
            )
            .frame(width: 49, height: 27)
            .overlayPolyfill {
                HStack(spacing: 0) {
                    if let action = self.action {
                        Button {
                            action()
                        } label: {
                            self.IconView()
                        }
                        .buttonStyle(.plain)
                        .pointerStyleLinkPolyfill()
                    } else {
                        self.IconView()
                    }
                    self.MenuStickerView()
                        .padding(.horizontal, -2)
                }
            }
    }

    @ViewBuilder private func IconView() -> some View {
        self.icon
            .contentShape(RoundedRectangle(cornerRadius: 5))
            .font(.system(size: 17))
            .foregroundStyle(
                self.colorScheme == .dark ?
                    Color.toolbar.iconDark :
                    Color.toolbar.icon
            )
    }

    @ViewBuilder private func MenuStickerView() -> some View {
        Menu("") {
            ForEach(self.contents.indices, id: \.self) { index in
                if let menuItem = self.contents[safe: index] {
                    AnyView(menuItem)
                }
            }
        }
        .menuStyle(.borderlessButton)
        .frame(width: 19, height: 20)
        .pointerStyleLinkPolyfill()
    }

    @ViewBuilder private func TitleView() -> some View {
        Text(self.title)
            .lineLimit(1)
            .font(.system(size: 11))
            .foregroundStyle(
                self.colorScheme == .dark ?
                    Color.toolbar.titleDark :
                    Color.toolbar.title
            )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ToolbarCustom_Preview.previews
}
