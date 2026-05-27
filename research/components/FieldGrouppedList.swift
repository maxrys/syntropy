
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct FieldGrouppedList<GroupID, ItemID>: View, @MainActor Equatable where GroupID: Hashable & Equatable & Comparable, ItemID: Hashable & Equatable & Comparable {

    static func == (lhs: FieldGrouppedList, rhs: FieldGrouppedList) -> Bool {
        lhs.state.value == rhs.state.value &&
        lhs.list        == rhs.list
    }

    @ObservedObject private var state: ValueState<ItemID>

    private let list: [
        GroupID: GruppedListItem<ItemID>
    ]

    init(value: ItemID, list: [GroupID: GruppedListItem<ItemID>], onChange: @escaping (ItemID) -> Void) {
        self.state = ValueState(value, onChange)
        self.list  = list
    }

    var body: some View {
        Picker("", selection: self.$state.value) {
            let groups = self.list.sorted(by: { (lhs, rhs) in lhs.key > rhs.key })
            ForEach(groups, id: \.key) { groupID, group in
                Section(header: Text(group.title).font(.system(size: 18))) {
                    let items = group.items.sorted(by: { (lhs, rhs) in lhs.key < rhs.key })
                    ForEach(items, id: \.key) { itemID, itemTitle in
                        Text(itemTitle).tag(itemID)
                    }
                }
            }
        }
    }

}
