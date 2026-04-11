
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToolbarCustom_Button: ToolbarCustom_Item_Protocol {

    @Environment(\.colorScheme) private var colorScheme

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
        VStack(spacing: 4) {
            self.ButtonView()
                .keyboardShortcutPolyfill(self.keyboardShortcut)
            self.TitleView()
                .frame(maxWidth: 35)
        }
    }

    @ViewBuilder private func ButtonView() -> some View {
        Button {
            self.action()
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(
                    self.colorScheme == .dark ?
                        Color.toolbar.iconBorderDark :
                        Color.toolbar.iconBorder,
                    style: StrokeStyle(lineWidth: 1)
                )
                .frame(width: 28, height: 27)
                .focusEffect(RoundedRectangle(cornerRadius: 5))
                .overlayPolyfill {
                    self.IconView()
                }
        }
        .buttonStyle(.plain)
        .pointerStyleLinkPolyfill()
    }

    @ViewBuilder private func IconView() -> some View {
        self.icon
            .focusEffect(RoundedRectangle(cornerRadius: 5))
            .font(.system(size: 17))
            .foregroundPolyfill(
                self.colorScheme == .dark ?
                    Color.toolbar.iconDark :
                    Color.toolbar.icon
            )
    }

    @ViewBuilder private func TitleView() -> some View {
        Text(self.title)
            .lineLimit(1)
            .font(.system(size: 11))
            .foregroundPolyfill(
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
