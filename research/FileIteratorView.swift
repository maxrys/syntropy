
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct FileIteratorView: View {

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

            Text("Progress: \(self.progress) %")

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
            self.progress = 0.0
            self.report = []
            for index in 0 ... 100 {
                try? await Task.sleep(
                    nanoseconds: 100_000_000
                )
                await MainActor.run {
                    self.progress = Double(index) / 100
                }
                if Task.isCancelled {
                    break
                }
            }
            self.task = nil
        }

    }

    private func cancelReading() {
        if let task = self.task {
            task.cancel()
            self.task = nil
        }
    }

}
