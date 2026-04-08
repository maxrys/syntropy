
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import Foundation
import ZIPFoundation

final class CompresCore: ObservableObject {

    @Published public private(set) var progress: Double = 0.0

    public let sourcePaths: [String]
    public let archivePath: String
    public let preset: CompresPreset
    public let sharedPrefix: String?

    private let archive: Archive

    init?(
        from sourcePaths: [String],
        to archivePath: String,
        preset: CompresPreset
    ) {
        do {
            self.sourcePaths = sourcePaths
            self.archivePath = archivePath
            self.preset = preset
            self.archive = try Archive(
                url: URL(fileURLWithPath: archivePath),
                accessMode: .create
            )
            if (self.preset.isTrimPrefix)
                 { self.sharedPrefix = FileManager.pathsSharedPrefix(sourcePaths) }
            else { self.sharedPrefix = nil }
        } catch {
            Logger.customLog("\(error.localizedDescription)")
            return nil
        }
    }

    public func start() {
        for sourcePath in self.sourcePaths {

            let internalPath = {
                if let sharedPrefix = self.sharedPrefix
                     { return sourcePath.trimPrefix(sharedPrefix) }
                else { return sourcePath }
            }()

            do {
                let fileHandle = try FileHandle(
                    forReadingFrom: URL(
                        fileURLWithPath: sourcePath
                    )
                )
                try self.archive.addEntry(
                    with: internalPath,
                    type: .file,
                    uncompressedSize: Int64(try fileHandle.seekToEnd()),
                    compressionMethod: self.preset.compression,
                ) { position, size -> Data in
                    try fileHandle.seek(toOffset: UInt64(position))
                    let data = try fileHandle.read(upToCount: Int(size)) ?? Data()
                    return data
                }
                try fileHandle.close()
            } catch {
            }

        }
    }

}
