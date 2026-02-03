
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct Toolbar: View {

    @State private var searchText = ""
    @State private var presets: [String: String] = [
        "Zip": "Zip — Regular",
        "7zH": "7z — Highly Compressed",
        "7zS": "7z — 10MB Split",
    ]

    let padding: EdgeInsets

    init(padding: EdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)) {
        self.padding = padding
    }

    public var body: some View {
        ToolbarCustom(padding: self.padding) {

            ToolbarCustom_Menu(
                title: NSLocalizedString("Add", comment: ""),
                icon: Image(systemName: "plus"),
                action: self.onClick_add
            ) {
                Button(
                    NSLocalizedString("New Folder", comment: ""),
                    action: self.onClick_addNewFolder
                ).keyboardShortcut(.init("N", modifiers: [.command, .shift]))

                Button(
                    NSLocalizedString("Files...", comment: ""),
                    action: self.onClick_addFiles
                ).keyboardShortcut(.init("A", modifiers: [.command, .shift]))
            }

            ToolbarCustom_Button(
                title: NSLocalizedString("Delete", comment: ""),
                icon: Image(systemName: "minus"),
                keyboardShortcut: .init("D", modifiers: [.command, .shift]),
                action: self.onClick_delete
            )

            ToolbarCustom_Spacer()

            ToolbarCustom_Button(
                title: NSLocalizedString("Extract", comment: ""),
                icon: Image(systemName: "rectangle.portrait.and.arrow.forward"),
                keyboardShortcut: .init("E", modifiers: [.command, .shift]),
                action: self.onClick_extract
            )

            ToolbarCustom_Menu(
                title: NSLocalizedString("Save", comment: ""),
                icon: Image(systemName: "gift"),
                action: self.onClick_save
            ) {
                Button(
                    NSLocalizedString("Save...", comment: ""),
                    action: self.onClick_saveAs
                ).keyboardShortcut(.init("S", modifiers: [.command, .shift]))

                Divider()

                Text("Save Using Preset")

                ForEach(self.presets.sorted(by: { lhs, rhs in lhs.value < rhs.value }), id: \.key) { name, title in
                    Button(String(repeating: " ", count: 5) + title) {
                        self.onClick_saveUsingPreset(name: name)
                    }
                }

                Divider()

                Button(
                    NSLocalizedString("Edit Presets...", comment: ""),
                    action: self.onClick_editPresets
                ).keyboardShortcut(.init("P", modifiers: [.command, .shift]))
            }

            ToolbarCustom_Spacer()

            ToolbarCustom_Button(
                title: NSLocalizedString("Test", comment: ""),
                icon: Image(systemName: "checkmark.seal"),
                keyboardShortcut: .init("T", modifiers: [.command, .shift]),
                action: self.onClick_test
            )

            ToolbarCustom_Spacer()
            ToolbarCustom_Spacer(flexibility: .infinity)

            ToolbarCustom_TextField(
                hint: NSLocalizedString("􀊫 Search", comment: ""),
                text: self.$searchText,
                minWidth: 100,
                maxWidth: 200,
                onChange: self.onChange_searchText
            )
         // .onChange(of: self.searchText, perform: self.onChange_searchText)

        }
    }

    private func onClick_add() {
        print("onClick_add")
    }

    private func onClick_addNewFolder() {
        print("onClick_addNewFolder")
    }

    private func onClick_addFiles() {
        print("onClick_addFiles")
    }

    private func onClick_delete() {
        print("onClick_delete")
    }

    private func onClick_extract() {
        print("onClick_extract")
    }

    private func onClick_save() {
        print("onClick_save")
    }

    private func onClick_saveAs() {
        print("onClick_saveAs")
    }

    private func onClick_saveUsingPreset(name: String) {
        print("onClick_saveUsingPreset: \(name)")
    }

    private func onClick_editPresets() {
        print("onClick_editPresets")
    }

    private func onClick_test() {
        print("onClick_test")
    }

    private func onChange_searchText() {
        print("onChange_searchText: \(self.searchText)")
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    VStack(spacing: 0) {
        Toolbar(padding: .init(top: 12, leading: 10, bottom: 10, trailing: 20))
        Spacer()
    }.frame(width: 500, height: 200)
}
