
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI

struct CompresCoreView: View {

    static let DEMO_FROM = "/Volumes/dev/xcode/syntropy/test/by_structure"
    static let DEMO_TO = "/Volumes/dev/xcode/syntropy/test/result/file.zip"

    @State private var compresCore: CompresCore?
    @State private var isTrimPrefix: Bool = true
    @State private var isCompressed: Bool = true

    init() {
    }

    var body: some View {
        VStack(spacing: 10) {

            HStack(spacing: 10) {

                Toggle(isOn: self.$isTrimPrefix) {
                    Text("Trim Prefix")
                }

                Toggle(isOn: self.$isCompressed) {
                    Text("Compressed")
                }

                Button("Compres") {
                    self.startCompress()
                }

                Button("Cancel") {
                    self.cancelCompress()
                }

            }

            ProgressView(
                value: self.compresCore?.progress ?? 0.0
            )

            ScrollView {
                if let compresCore = self.compresCore {
                    ForEach (compresCore.report.indices.reversed(), id: \.self) { index in
                        Text(compresCore.report[index]).id(index)
                    }
                }
            }

        }
        .padding(20)
        .background(Color.white)
        .onDisappear {
        }
    }

    private func startCompress() {
        self.compresCore = CompresCore(
            from: FileManager.pathScanRecursive(Self.DEMO_FROM),
            to: FileManager.pathToSafePath(Self.DEMO_TO),
            preset: CompresPreset(
                isTrimPrefix: self.isTrimPrefix,
                compression: self.isCompressed ? .deflate : .none
            )
        )
        self.compresCore?.start()
    }

    private func cancelCompress() {
    }

}
