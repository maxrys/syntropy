
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TabCustom: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var selected: Int = 0

    private let contents: [any TabCustom_Item_Protocol]

    init(@ViewBuilderArray<TabCustom_Item_Protocol> content: () -> [any TabCustom_Item_Protocol]) {
        self.contents = content()
    }

    private var colorHeadBackground: Color {
        self.colorScheme == .dark ?
            Color.tab.headBackgroundDark :
            Color.tab.headBackground
    }

    public var body: some View {
        VStack(spacing: 0) {

            /* MARK: Tab Header */

            HStack(spacing: 10) {
                ForEach(self.contents.indices, id: \.self) { index in
                    if let tatSpacer = self.contents[safe: index] as? TabCustom_Spacer { tatSpacer }
                    if let tabItem   = self.contents[safe: index] as? TabCustom_Item {
                        TabCustom_HeadTitle(
                            title: tabItem.title,
                            icon: tabItem.icon,
                            index: index,
                            isSelected: self.selected == index) { index in
                                self.selected = index
                            }
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(self.colorHeadBackground)

            /* MARK: Tab Body */

            VStack {
                if let tabItem = self.contents[safe: self.selected] as? TabCustom_Item {
                    tabItem.frame(maxWidth: .infinity)
                }
            }.frame(
                maxWidth : .infinity,
                maxHeight: .infinity
            )

        }.frame(maxWidth: .infinity)
    }

}

fileprivate struct TabCustom_HeadTitle: View {

    @Environment(\.colorScheme) private var colorScheme

    @State fileprivate var isHovering = false

    fileprivate let title: String
    fileprivate let icon: Image?
    fileprivate let index: Int
    fileprivate let isSelected: Bool
    fileprivate let onClick: (Int) -> Void

    private var colorBorder: Color {
        if (self.isHovering != true && self.colorScheme != .dark) { return .tab.headTitleBorder             }
        if (self.isHovering != true && self.colorScheme == .dark) { return .tab.headTitleBorderDark         }
        if (self.isHovering == true && self.colorScheme != .dark) { return .tab.headTitleBorderHovering     }
        if (self.isHovering == true && self.colorScheme == .dark) { return .tab.headTitleBorderHoveringDark }
        return .clear
    }

    private var colorForeground: Color {
        if (self.isSelected != true && self.colorScheme != .dark) { return .tab.headTitle             }
        if (self.isSelected != true && self.colorScheme == .dark) { return .tab.headTitleDark         }
        if (self.isSelected == true && self.colorScheme != .dark) { return .tab.headTitleSelected     }
        if (self.isSelected == true && self.colorScheme == .dark) { return .tab.headTitleSelectedDark }
        return .clear
    }

    private var colorBackground: Color {
        self.isSelected ?
            .tab.headTitleSelectedBackground :
            .tab.headTitleBackground
    }

    public var body: some View {
        Button {
            self.onClick(self.index)
        } label: {
            VStack(spacing: 7) {
                if let icon {
                    icon.resizable()
                        .frame(width: 25, height: 25)
                }
                if (!title.isEmpty) {
                    Text(title)
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(10)
            .foregroundPolyfill(self.colorForeground)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(self.colorBackground)
                    .overlayPolyfill {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 4))
                            .foregroundPolyfill(self.colorBorder)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .focusEffect (RoundedRectangle(cornerRadius: 10))
            )
        }
        .buttonStyle(.plain)
        .pointerStyleLinkPolyfill()
        .onHover { isHovering in
            self.isHovering = isHovering
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    TabCustom {
        TabCustom_Item(title: NSLocalizedString("Title 1", comment: ""), icon: Image(systemName: "1.square")) { Text("Tab 1 Content").padding(20) }
        TabCustom_Item(title: NSLocalizedString("Title 2", comment: ""), icon: Image(systemName: "2.square")) { Text("Tab 2 Content").padding(20) }; TabCustom_Spacer()
        TabCustom_Item(title: NSLocalizedString("Title 3", comment: ""), icon: Image(systemName: "3.square")) { Text("Tab 3 Content").padding(20) }
    }.frame(width: 400, height: 300)
}
