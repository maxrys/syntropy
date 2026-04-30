
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import ZIPFoundation

struct CompresSequenceView: View {

    static private let MESSAGE_STATUS_SUCCESS_LOCALIZED        = NSLocalizedString("success", comment: "")
    static private let MESSAGE_STATUS_FAILURE_LOCALIZED        = NSLocalizedString("failure", comment: "")
    static private let MESSAGE_STATUS_TASK_CANCELLED_LOCALIZED = NSLocalizedString("Task was cancelled.", comment: "")

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0
    @State private var task: Task<Void, Never>? = nil
    @State private var isRelativePath: Bool = true
    @State private var isIncludeEmptyDirs: Bool = true
    @State private var isCompressed: Bool = true
    @State private var throttlingIndex: Int = 0
    @State private var report: [(path: String, description: String)] = []

    private let throttlingValues: [Double] = [0, 0.0001, 0.001, 0.01, 0.1]

    private var sourcesInfo: CompresSource = {
        var info = CompresSource()
        _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_structure/")
        _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/file.txt")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/archive.zip")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/folder.extension")
     // _ = info.addSource(path: "/Volumes/dev/xcode/syntropy/test/by_types/folder")
        Logger.customLog("\nFILES:")           ; for object in info.files           .sorted(by: { (lhs, rhs) in lhs.absolute < rhs.absolute}) { Logger.customLog("- \(object.date!.created.ISO8601withTZ) \(object.date!.updated.ISO8601withTZ) | \(object.absolute.width(90)) | \(object.relative)") }
        Logger.customLog("\nLINKS:")           ; for object in info.links           .sorted(by: { (lhs, rhs) in lhs.absolute < rhs.absolute}) { Logger.customLog("- \(object.date!.created.ISO8601withTZ) \(object.date!.updated.ISO8601withTZ) | \(object.absolute.width(90)) | \(object.relative)") }
        Logger.customLog("\nDIRECTORIES:")     ; for object in info.directories     .sorted(by: { (lhs, rhs) in lhs.absolute < rhs.absolute}) { Logger.customLog("- \(object.date!.created.ISO8601withTZ) \(object.date!.updated.ISO8601withTZ) | \(object.absolute.width(90)) | \(object.relative)") }
        Logger.customLog("\nEMPTYDIRECTORIES:"); for object in info.emptyDirectories.sorted(by: { (lhs, rhs) in lhs.absolute < rhs.absolute}) { Logger.customLog("- \(object.date!.created.ISO8601withTZ) \(object.date!.updated.ISO8601withTZ) | \(object.absolute.width(90)) | \(object.relative)") }
        return info
    }()

    private var archivePath: String {
        FileManager.pathToSafePath(
            "/Volumes/dev/xcode/syntropy/test/result/file.zip"
        )
    }

    private var preset: CompresPreset {
        CompresPreset(
            isRelativePath    : self.isRelativePath,
            isIncludeEmptyDirs: self.isIncludeEmptyDirs,
            isFollowLinks     : true,
            compression       : self.isCompressed ? .deflate : .none,
            throttling        : self.throttlingValues[self.throttlingIndex],
            excludePattern    : nil,
            date              : .current
        )
    }

    init() {
    }

    var body: some View {
        VStack(spacing: 20) {

            HStack(spacing: 20) {

                Toggle(isOn: self.$isRelativePath) {
                    Text("isRelativePath")
                }.disabled(self.task != nil)

                Toggle(isOn: self.$isCompressed) {
                    Text("isCompressed")
                }.disabled(self.task != nil)

                Toggle(isOn: self.$isIncludeEmptyDirs) {
                    Text("isIncludeEmptyDirs")
                }.disabled(self.task != nil)

                Picker("Throttling", selection: self.$throttlingIndex) {
                    ForEach(self.throttlingValues.indices, id: \.self) { index in
                        Text("\(self.throttlingValues[index])").id(index)
                    }
                }.frame(width: 160)
                .disabled(self.task != nil)

            }

            VStack(spacing: 5) {

                ProgressCustom(value: self.progressTotal)
                Text("Progress: \(Int(self.progressTotal * 100)) %")

                ProgressCustom(value: self.progressLocal)
                Text("Progress: \(Int(self.progressLocal * 100)) %")

            }

            HStack(spacing: 10) {

                Button("Compress") {
                    self.onClickStart()
                }.disabled(self.task != nil)

                Button("Cancel") {
                    self.onClickCancel()
                }.disabled(self.task == nil)

            }

            ScrollView {
                let columns = [
                    GridItem(.flexible(), spacing: 0, alignment: .leading),
                    GridItem(.fixed(200), spacing: 0, alignment: .center),
                ]
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach (self.report.indices.reversed(), id: \.self) { index in
                        let reportInfo = self.report[index]
                        Text(reportInfo.path       ).id(Double(index) + 0.1)
                        Text(reportInfo.description).id(Double(index) + 0.2)
                    }
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
                        case .failure(_, let text): self.report.append((path: result.sourcePath, description: Self.MESSAGE_STATUS_FAILURE_LOCALIZED + ": " + text))
                        case .success             : self.report.append((path: result.sourcePath, description: Self.MESSAGE_STATUS_SUCCESS_LOCALIZED))
                        case .cancelledByUser     : self.report.append((path: result.sourcePath, description: Self.MESSAGE_STATUS_TASK_CANCELLED_LOCALIZED))
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
