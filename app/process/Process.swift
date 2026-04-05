
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct Process: View {

    let appURL: AppURL

    public var body: some View {
        VStack {
            Text(self.appURL.operationType.rawValue)
            Text(self.appURL.paths.joined(separator: "\n"))
        }.frame(width: 500, height: 100)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Process(
        appURL: AppURL(operationType: .compres, ["/test"])
    )
}
