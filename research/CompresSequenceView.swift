
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import ZIPFoundation

struct CompresSequenceView: View {

    static let DEMO_PATH_FROM = "/Volumes/dev/xcode/syntropy/test/by_structure"
    static let DEMO_PATH_TO = "/Volumes/dev/xcode/syntropy/test/result/file.zip"

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0
    @State private var task: Task<Void, Never>? = nil
    @State private var isTrimPrefix: Bool = true
    @State private var isCompressed: Bool = true
    @State private var report: [String] = []

    private var pathsFrom: [String] {FileManager.pathScanRecursive(Self.DEMO_PATH_FROM)?.files ?? []}
    private var pathTo:     String  {FileManager.pathToSafePath   (Self.DEMO_PATH_TO  )}
    private var preset: CompresPreset {
        CompresPreset(
            isTrimPrefix: self.isTrimPrefix,
            compression : self.isCompressed ? .deflate : .none
        )
    }

    init() {
    }

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
                    self.onClickStart()
                }.disabled(self.task != nil)

                Button("Cancel") {
                    self.onClickCancel()
                }.disabled(self.task == nil)

            }

            ProgressCustom(value: self.progressTotal); Text("Progress: \(Int(self.progressTotal * 100)) %")
            ProgressCustom(value: self.progressLocal); Text("Progress: \(Int(self.progressLocal * 100)) %")

            ScrollView {
                ForEach (self.report.indices.reversed(), id: \.self) { index in
                    Text(self.report[index]).id(index)
                }
            }

        }
        .padding(20)
        .background(Color.white)
        .onDisappear {
            self.onClickCancel()
        }
    }

    private func onClickStart() {
        if let compressSequence = CompresSequence(
            from         : self.pathsFrom,
            to           : self.pathTo,
            preset       : self.preset,
            progressTotal: self.$progressTotal,
            progressLocal: self.$progressLocal
        ) {
            self.task = Task {
                self.report = []
                let iterator = compressSequence.makeAsyncIterator()
                process: while let result = await iterator.next() {
                    switch result.status {
                        case .failure(_, let text): self.report.append("\(result.sourcePath) → " + NSLocalizedString("failure", comment: "") + ": " + text)
                        case .success             : self.report.append("\(result.sourcePath) → " + NSLocalizedString("success", comment: ""))
                        case .cancelledByUser     : self.report.append(NSLocalizedString("Task was cancelled.", comment: ""))
                            try? FileManager.default.removeItem(
                                at: URL(fileURLWithPath: compressSequence.archivePath)
                            )
                            break process
                    }
                }
                self.task = nil
            }
        }
    }

    private func onClickCancel() {
        if let task = self.task {
            task.cancel()
            self.task = nil
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    CompresSequenceView()
}
