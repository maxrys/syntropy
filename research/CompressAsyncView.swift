
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import ZIPFoundation

struct CompressAsyncView: View {

    static let DEMO_FROM = "/Volumes/dev/xcode/syntropy/test/by_structure"
    static let DEMO_TO = "/Volumes/dev/xcode/syntropy/test/result/file.zip"

    @State private var task: Task<Void, Never>? = nil
    @State private var isTrimPrefix: Bool = true
    @State private var isCompressed: Bool = true
    @State private var progress: Double = 0.0
    @State private var report: [String] = []

    var body: some View {
        VStack(spacing: 10) {

            HStack(spacing: 10) {

                Toggle(isOn: self.$isTrimPrefix) {
                    Text("Trim Prefix")
                }.disabled(self.task != nil)

                Toggle(isOn: self.$isCompressed) {
                    Text("Compressed")
                }.disabled(self.task != nil)

                Button("Compres") {
                    self.startCompress()
                }.disabled(self.task != nil)

                Button("Cancel") {
                    self.cancelCompress()
                }.disabled(self.task == nil)

            }

            ProgressView(
                value: self.progress
            )

            ScrollView {
                ForEach (self.report.indices.reversed(), id: \.self) { index in
                    Text(self.report[index]).id(index)
                }
            }

        }
        .padding(20)
        .background(Color.white)
    }

    private func startCompress() {
        self.task = Task {
            if let compressSequence = CompresAsync(
                from: FileManager.pathScanRecursive(Self.DEMO_FROM),
                to: FileManager.pathToSafePath(Self.DEMO_TO),
                preset: CompresPreset(
                    isTrimPrefix: self.isTrimPrefix,
                    compression: self.isCompressed ? .deflate : .none
                )
            ) {
                self.progress = 0.0
                self.report = []
                process: for await result in compressSequence {
                    self.progress = result.progress
                    switch result.value {
                        case .failure(_, let text): self.report.append("\(result.object) → " + NSLocalizedString("failure", comment: "") + ": " + text)
                        case .success             : self.report.append("\(result.object) → " + NSLocalizedString("success", comment: ""))
                        case .cancellationByUser  : self.report.append(NSLocalizedString("Task was cancelled.", comment: ""))
                            try? FileManager.default.removeItem(
                                at: URL(fileURLWithPath: compressSequence.archivePath)
                            )
                            break process
                    }
                }
                self.progress = 1.0
                self.task = nil
            }
        }
    }

    private func cancelCompress() {
        if let task = self.task {
            task.cancel()
            self.task = nil
        }
    }

}
