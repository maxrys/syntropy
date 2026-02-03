
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol TabCustom_Item_Protocol: View {
}

struct TabCustom: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var selected: Int = 0

    private let contents: [any TabCustom_Item_Protocol]

    init(@ViewBuilderArray<TabCustom_Item_Protocol> content: () -> [any TabCustom_Item_Protocol]) {
        self.contents = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            /* MARK: Tab Header */

            HStack(spacing: 10) {
                ForEach(0 ..< self.contents.count, id: \.self) { index in
                    if let tatSpacer = self.contents[safe: index] as? TabCustom_Spacer { tatSpacer }
                    if let tabItem   = self.contents[safe: index] as? TabCustom_Item {
                        TabCustom_header(
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
            .background(
                self.colorScheme == .dark ?
                    .black.opacity(0.2) :
                    .white.opacity(0.5)
            )

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

fileprivate struct TabCustom_header: View {

    @Environment(\.colorScheme) fileprivate var colorScheme

    @State fileprivate var isHovering = false

    fileprivate let title: String
    fileprivate let icon: Image?
    fileprivate let index: Int
    fileprivate let isSelected: Bool
    fileprivate let onClick: (Int) -> Void

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
                        .font(.system(size: 12))
                }
            }
            .foregroundStyle(
                self.isSelected ? Color.white :
                    (self.colorScheme == .dark ?
                        Color.white :
                        Color.black
                    )
            )
            .padding(10)
            .background {
                if (self.isSelected) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 4))
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle({
                            if (self.isHovering) {
                                return Color.accentColor } else {
                                return self.colorScheme == .dark ?
                                    Color.white.opacity(0.1) :
                                    Color.black.opacity(0.1)
                            }
                        }())
                }
            }
            .contentShape(.focusEffect, RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .pointerStyleLinkPolyfill()
        .onHover { isHovering in
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isHovering = isHovering
            }
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
