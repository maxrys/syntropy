
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct FileIteratorView: View {

    static let DEMO_PATH = "/Volumes/dev/xcode/syntropy/test/by_structure/big_files/bigFile1.zip"

    @State private var task: Task<Void, Never>? = nil
    @State private var progress: Double = 0.0
    @State private var report: [String] = []

    var body: some View {
        VStack(spacing: 10) {

            HStack(spacing: 10) {

                Button("Reading") {
                    self.startReading()
                }.disabled(self.task != nil)

                Button("Cancel") {
                    self.cancelReading()
                }.disabled(self.task == nil)

            }

            ProgressCustom(
                value: self.$progress
            )

            Text("Progress: \(Int(self.progress * 100)) %")

            ScrollView {
                ForEach (self.report.indices.reversed(), id: \.self) { index in
                    Text(self.report[index]).id(index)
                }
            }

        }
        .padding(20)
        .background(Color.white)
        .onDisappear {
        }
    }

    private func startReading() {
        self.task = Task {
            if let fileSequence = FileSequence(path: Self.DEMO_PATH) {
                self.progress = 0.0
                self.report = []
                process: for await result in fileSequence {
                    self.progress = result.progress
                    switch result.status {
                        case .failure(_, let text): self.report.append(NSLocalizedString("failure", comment: "") + ": " + text)
                        case .success             : self.report.append(NSLocalizedString("success", comment: "") + ": offset = \(result.offset) | progress = \(result.progress)")
                        case .cancellationByUser  : self.report.append(NSLocalizedString("Task was cancelled.", comment: "")); break process
                    }
                    try? await Task.sleep(
                        nanoseconds: 1_000_000
                    )
                }
                self.task = nil
            }
        }

    }

    private func cancelReading() {
        if let task = self.task {
            task.cancel()
            self.task = nil
        }
    }

}
