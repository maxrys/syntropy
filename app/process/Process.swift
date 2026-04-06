
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import ZIPFoundation

struct Process: View {

    let appURL: AppURL

    public var body: some View {
        VStack {
            Text(self.appURL.operationType.rawValue)
            Text(self.appURL.paths.joined(separator: "\n"))
        }.frame(width: 500, height: 100)
    }

    func processCompres() {
        /*
        let fileManager = FileManager.default
        let sourceURL = URL(fileURLWithPath: "/path/to/sourceFolder")
        let archiveURL = URL(fileURLWithPath: "/path/to/newArchive.zip")

        do {
            if fileManager.fileExists(atPath: archiveURL.path) {
                try fileManager.removeItem(at: archiveURL)
            }
            guard let archive = Archive(url: archiveURL, accessMode: .create) else { throw NSError(domain: "ZIP", code: 2) }

            let resourceKeys: [URLResourceKey] = [.isDirectoryKey]
            let enumerator = fileManager.enumerator(at: sourceURL, includingPropertiesForKeys: resourceKeys)!

            for case let fileURL as URL in enumerator {
                let relativePath = fileURL.path.replacingOccurrences(of: sourceURL.path + "/", with: "")
                if let isDirectory = try fileURL.resourceValues(forKeys: Set(resourceKeys)).isDirectory, isDirectory {
                    try archive.addEntry(with: relativePath + "/", type: .directory, uncompressedSize: 0, compressionMethod: .none)
                } else {
                    try archive.addEntry(with: relativePath, relativeTo: sourceURL)
                }
            }
        } catch {
            print("Ошибка упаковки: \(error)")
        }
        */
        /*

         */
    }

    func processExtract() {
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Process(
        appURL: AppURL(operationType: .compres, ["/test"])
    )
}
