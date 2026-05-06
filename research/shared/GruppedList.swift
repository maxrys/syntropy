
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

public struct GruppedListItem<ItemID>: Equatable where ItemID: Hashable {
    var title: String
    var items: [
        ItemID: String
    ]
}
