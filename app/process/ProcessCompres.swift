
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import ZIPFoundation

struct ProcessCompres: View {

    static let DEMO_PATH_TO = "/Volumes/dev/xcode/syntropy/test/result/file.zip"
    static let DEFAULT_COMPRES_PRESET = CompresPreset(
        isTrimPrefix: true,
        compression: .deflate
    )

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0
    @State private var task: Task<Void, Never>? = nil
    @State private var report: [String] = []

    private let pathsFrom: [String]
    private let pathTo: String
    private let preset: CompresPreset

    init(appURLPaths: [String]) {
        self.pathsFrom = appURLPaths.reduce(into: [String](), { result, path in
            result += FileManager.pathScanRecursive(path)
        })
// dump(appURLPaths)
// dump(self.pathsFrom)
        self.pathTo = Self.DEMO_PATH_TO
        self.preset = Self.DEFAULT_COMPRES_PRESET
    }

    public var body: some View {
        VStack(spacing: 10) {

            ProgressCustom(value: self.progressTotal)
            ProgressCustom(value: self.progressLocal)

            HStack(spacing: 10) {

                Button("Compres") {
                    self.onClickStart()
                }.disabled(self.task != nil)

                Button("Cancel") {
                    self.onClickCancel()
                }.disabled(self.task == nil)

            }

            if (!self.report.isEmpty) {
                ScrollView {
                    ForEach (self.report.indices.reversed(), id: \.self) { index in
                        Text(self.report[index]).id(index)
                    }
                }.background(Color.white)
            }

        }
        .padding(20)
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
    ProcessCompres(
        appURLPaths: [
            "/test/1",
            "/test/2",
            "/test/3",
        ]
    ).frame(width: 400)
}
