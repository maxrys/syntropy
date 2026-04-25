
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import ZIPFoundation

struct ProcessCompres: View {

    @State private var progressTotal: Double = 0.0
    @State private var progressLocal: Double = 0.0
    @State private var task: Task<Void, Never>? = nil
    @State private var isTrimPrefix: Bool = true
    @State private var isCompressed: Bool = true
    @State private var report: [String] = []

    private let pathsFrom: [String]
    private let pathTo: String = ""

    init(pathsFrom: [String]) {
        self.pathsFrom = pathsFrom
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
        pathsFrom: [
            "/test/1",
            "/test/2",
            "/test/3",
        ]
    ).frame(width: 400)
}
