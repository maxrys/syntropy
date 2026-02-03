
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainScene: View {

    @State public var url: URL?

    public var body: some View {
        Group {
            if let url = self.url {
                Text(url.absoluteString.trimPrefix(URL_PREFIX_THIS_APP))
            } else {
                Text("No URL")
            }
        }.onOpenURL { url in
            self.url = url
        }
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
