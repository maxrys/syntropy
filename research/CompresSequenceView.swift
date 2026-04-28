
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import ZIPFoundation

struct CompresSequenceView: View {

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0
    @State private var task: Task<Void, Never>? = nil
    @State private var isTrimPrefix: Bool = true
    @State private var isIncludeEmptyDirs: Bool = true
    @State private var isCompressed: Bool = true
    @State private var report: [String] = []

    private var sourcesInfo: CompresSourceInfo = {
        var info = CompresSourceInfo()
        _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_structure/")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/file.txt")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/archive.zip")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/folder.extension")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/folder")
        return info
    }()

    private var archivePath: String {
        FileManager.pathToSafePath(
            "/Volumes/dev/xcode/syntropy/test/result/file.zip"
        )
    }

    private var preset: CompresPreset {
        CompresPreset(
            isTrimPrefix      : self.isTrimPrefix,
            isIncludeEmptyDirs: self.isIncludeEmptyDirs,
            compression       : self.isCompressed ? .deflate : .none
        )
    }

    init() {
    }

    var body: some View {
        VStack(spacing: 10) {

            HStack(spacing: 10) {

                Toggle(isOn: self.$isTrimPrefix) {
                    Text("isTrimPrefix")
                }.disabled(self.task != nil)

                Toggle(isOn: self.$isCompressed) {
                    Text("isCompressed")
                }.disabled(self.task != nil)

                Toggle(isOn: self.$isIncludeEmptyDirs) {
                    Text("isIncludeEmptyDirs")
                }.disabled(self.task != nil)

            }

            HStack(spacing: 10) {

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
            sourcesInfo  : self.sourcesInfo,
            archivePath  : self.archivePath,
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
