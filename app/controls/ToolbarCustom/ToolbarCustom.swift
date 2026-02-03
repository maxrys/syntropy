
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol ToolbarCustom_item_Protocol: View {
}

struct ToolbarCustom: View {

    static let BUTTON_WIDTH: CGFloat = 28
    static let BUTTON_HEIGHT: CGFloat = 27
    static let BUTTON_CORNER_RADIUS: CGFloat = 5
    static let BUTTON_AND_TITLE_SPACING: CGFloat = 4
    static let ICON_FONT_SIZE: CGFloat = 17
    static let TITLE_FONT_SIZE: CGFloat = 11

    static let ICON_COLOR            : Color = .black.opacity(0.5)
    static let ICON_COLOR_DARK       : Color = .white.opacity(0.6)
    static let ICON_BORDER_COLOR     : Color = .black.opacity(0.05)
    static let ICON_BORDER_COLOR_DARK: Color = .white.opacity(0.05)
    static let TITLE_COLOR           : Color = .black.opacity(0.5)
    static let TITLE_COLOR_DARK      : Color = .white.opacity(0.6)

    @Environment(\.colorScheme) private var colorScheme

    private let contents: [any ToolbarCustom_item_Protocol]
    private let padding: EdgeInsets

    init(
        padding: EdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10),
        @ViewBuilderArray<ToolbarCustom_item_Protocol> content: () -> [any ToolbarCustom_item_Protocol]
    ) {
        self.contents = content()
        self.padding = padding
    }

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(0 ..< self.contents.count, id: \.self) { index in
                if let toolbarElement = self.contents[safe: index] {
                    AnyView(toolbarElement)
                }
            }
        }
        .padding(self.padding)
        .frame(maxWidth: .infinity)
        .background(
            self.colorScheme == .dark ?
                .black.opacity(0.4) :
                .white.opacity(0.4)
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct ToolbarCustom_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ToolbarCustom(padding: .init(top: 12, leading: 20, bottom: 10, trailing: 20)) {
                ToolbarCustom_Button(
                    title: "Title",
                    icon: Image(systemName: "plus"),
                    keyboardShortcut: KeyboardShortcut("A", modifiers: [.command, .shift]),
                    action: {}
                )
                ToolbarCustom_Button(
                    title: "Long Title",
                    icon: Image(systemName: "minus"),
                    keyboardShortcut: KeyboardShortcut("B", modifiers: [.command, .shift]),
                    action: {}
                )
                ToolbarCustom_Spacer()
                ToolbarCustom_Menu(
                    title: "Menu",
                    icon: Image(systemName: "checkmark.seal")
                ) {
                    Button(NSLocalizedString("Menu item 1", comment: ""), action: { } ).keyboardShortcut(.init("1", modifiers: [.command, .shift]))
                    Button(NSLocalizedString("Menu item 2", comment: ""), action: { } ).keyboardShortcut(.init("2", modifiers: [.command, .shift]))
                    Button(NSLocalizedString("Menu item 3", comment: ""), action: { } ).keyboardShortcut(.init("3", modifiers: [.command, .shift]))
                }
                ToolbarCustom_Menu(
                    title: "Menu",
                    icon: Image(systemName: "checkmark.seal"),
                    action: { print("menu with action") }
                ) {
                    Button(NSLocalizedString("Menu item 4", comment: ""), action: { } ).keyboardShortcut(.init("4", modifiers: [.command, .shift]))
                    Button(NSLocalizedString("Menu item 5", comment: ""), action: { } ).keyboardShortcut(.init("5", modifiers: [.command, .shift]))
                    Button(NSLocalizedString("Menu item 6", comment: ""), action: { } ).keyboardShortcut(.init("6", modifiers: [.command, .shift]))
                }
                ToolbarCustom_Spacer(flexibility: .infinity)
                ToolbarCustom_TextField(
                    hint: NSLocalizedString("􀊫 Search", comment: ""),
                    text: Binding.constant(""),
                    minWidth: 100,
                    maxWidth: 200,
                    onChange: {}
                )
            }
            Spacer()
        }.frame(width: 400, height: 200)
    }
}
