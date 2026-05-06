
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct FieldList<ItemID>: View, @MainActor Equatable where ItemID: Hashable & Equatable & Comparable {

    static func == (lhs: FieldList, rhs: FieldList) -> Bool {
        lhs.state.value == rhs.state.value &&
        lhs.items       == rhs.items
    }

    @ObservedObject private var state: ValueState<ItemID>

    private let items: [
        ItemID: String
    ]

    init(value: ItemID, items: [ItemID: String], onChange: @escaping (ItemID) -> Void) {
        self.state = ValueState(value, onChange)
        self.items = items
    }

    var body: some View {
        Picker("", selection: self.$state.value) {
            ForEach(Array(self.items.sorted(by: { (lhs, rhs) in lhs.key < rhs.key }).enumerated()), id: \.element.key) { index, element in
                Text("\(String(element.value))").tag(element.key)
            }
        }
    }

}
