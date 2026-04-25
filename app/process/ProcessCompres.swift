
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import ZIPFoundation

struct ProcessCompres: View {

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0
    @State private var task: Task<Void, Never>? = nil
    @State private var isTrimPrefix: Bool = true
    @State private var isCompressed: Bool = true
    @State private var report: [String] = []

    private let pathsFrom: [String]
    private let pathTo: String = ""

    init(pathsFrom: [String]) {
        self.pathsFrom = pathsFrom
    }

    public var body: some View {
        VStack {
            Text(self.pathsFrom.joined(separator: "\n"))
        }.frame(width: 500, height: 100)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ProcessCompres(
        pathsFrom: [
            "/test/1",
            "/test/2",
            "/test/3",
        ]
    )
}
