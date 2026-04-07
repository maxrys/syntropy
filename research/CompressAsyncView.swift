
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import ZIPFoundation

struct CompressAsyncView: View {

    static let DEMO_FROM = "/Volumes/dev/xcode/syntropy/test/by_structure"
    static let DEMO_TO = "/Volumes/dev/xcode/syntropy/test/result/file.zip"

    @State private var isTrimPrefix: Bool = true
    @State private var isActive: Bool = false
    @State private var progress: Double = 0.0
    @State private var progressLog: [String] = []

    var body: some View {
        VStack(spacing: 10) {

            HStack(spacing: 10) {

                Toggle(isOn: self.$isTrimPrefix) {
                    Text("Trim Prefix")
                }.disabled(self.isActive)

                Button("Compres") {
                    self.startCompress()
                }.disabled(self.isActive)

            }

            ProgressView(
                value: self.progress
            )

            ScrollView {
                ForEach (self.progressLog.indices.reversed(), id: \.self) { index in
                    Text(self.progressLog[index]).id(index)
                }
            }.frame(maxHeight: 300)

        }
        .padding(20)
        .background(Color.white)
    }

    private func startCompress() {
        Task {
            if let compressSequence = CompresAsync(
                from: FileManager.pathScanRecursuve(Self.DEMO_FROM),
                to: FileManager.pathToSafePath(Self.DEMO_TO),
                isTrimPrefix: self.isTrimPrefix
            ) {
                self.progress = 0.0
                self.progressLog = []
                self.isActive = true
                for await result in compressSequence {
                    self.progress = result.progress
                    self.progressLog.append(
                        "\(result.path) → " + (result.isSuccessed ? NSLocalizedString("ok", comment: "") : NSLocalizedString("fail", comment: ""))
                    )
                }
                self.isActive = false
            }
        }
    }

}
