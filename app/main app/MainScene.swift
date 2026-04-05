
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainScene: View {

    @State private var demoProgress: Double = 0.5
    @State private var url: URL?

    public var body: some View {
        Group {
            if let url = self.url {
                Text(url.path)
            } else {
                ProgressCustom(value: self.$demoProgress).padding(20)
                Text("No URL")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    MainScene()
        .padding(20)
        .frame(width: 300, height: 200)
}
