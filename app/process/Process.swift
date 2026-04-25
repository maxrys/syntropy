
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import ZIPFoundation

struct Process: View {

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0

    private let appURL: AppIncomingURL

    init(appURL: AppIncomingURL) {
        self.appURL = appURL
    }

    public var body: some View {
        VStack {
            Text(self.appURL.operationType.rawValue)
            Text(self.appURL.paths.joined(separator: "\n"))
        }.frame(width: 500, height: 100)
    }

    func processCompres() {
    }

    func processExtract() {
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Process(
        appURL: AppIncomingURL(
            operationType: .compres, ["/test"]
        )
    )
}
