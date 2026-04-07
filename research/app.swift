
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import ZIPFoundation

@main struct ThisApp: App {

    @State private var isTrimPrefix: Bool = false
    @State private var progress: Double = 0.0
    @State private var description: String = "n/a"

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 50) {
                CompressAsyncView()
                FileManagerView()
            }.padding(50)
        }
    }

    @ViewBuilder func CompressAsyncView() -> some View {
        VStack(spacing: 10) {

            Toggle(isOn: self.$isTrimPrefix) {
                Text("Trim prefix")
            }

            ProgressView(value: self.progress)
                .progressViewStyle(LinearProgressViewStyle())

            Text("\(self.description)")

            Button("test ProgressView") {
                Task {
                    for await result in CompresAsync(3) {
                        self.progress = result.progress
                        self.description = "index: \(result.index) | isSuccessed: \(result.isSuccessed)"
                    }
                }
            }

            Button("Archivator.compres()") {
                Archivator.compres(
                    from: FileManager.pathScanRecursuve(
                        "/Volumes/dev/xcode/syntropy/test/by_structure"
                    ),
                    to: FileManager.pathToSafePath(
                        "/Volumes/dev/xcode/syntropy/test/result/file.zip"
                    ),
                    isTrimPrefix: self.isTrimPrefix
                )
            }

        }
    }

    @ViewBuilder func FileManagerView() -> some View {
        VStack(spacing: 10) {

            Button("Archivator.pathToSafePath()") {
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder") )
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/folder.extension") )
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file_noExtension") )
                Logger.customLog( FileManager.pathToSafePath("/Volumes/dev/xcode/syntropy/test/by_types/file.txt") )
            }

            Button("FileManager.pathScanRecursuve()") {
                dump(
                    FileManager.pathScanRecursuve(
                        "/Volumes/dev/xcode/syntropy/test/by_structure"
                    )
                )
            }

            Button("Archivator.trimSharedPathPrefix()") {
                dump(
                    FileManager.pathsTrimSharedPrefix([
                        "/Volumes/dev/xcode/syntropy/test/by_structure/nested folder 1/nested file 1.txt",
                        "/Volumes/dev/xcode/syntropy/test/by_structure/nested folder 2/nested file 5.txt",
                        "/Volumes/dev/xcode/syntropy/test/by_structure/file 1.txt",
                    ])
                )
            }

        }
    }

}
