
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

final class CompresCore: ObservableObject {

    @Published public private(set) var progress: Double = 0.0
    @Published public private(set) var report: [String] = []

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

    private func calculateProgress(current: any BinaryInteger, maximum: any BinaryInteger) -> Double {
        let result = Double(current) / Double(maximum)
        return result.isNaN ? 0 : result.fixBounds(
            min: 0.0,
            max: 1.0
        )
    }

    public func start() {

        self.progress = 0.0
        self.report = []

        for (index, sourcePath) in self.sourcePaths.enumerated() {

            let internalPath = {
                if let sharedPrefix = self.sharedPrefix
                     { return sourcePath.trimPrefix(sharedPrefix) }
                else { return sourcePath }
            }()

            do {
                self.report.append("\(sourcePath)")
                try self.addFile(
                    from: sourcePath,
                    as: internalPath
                )
            } catch {
            }

            self.progress = self.calculateProgress(
                current: index + 1,
                maximum: self.sourcePaths.count
            )

        }

        self.progress = 1.0
    }

    private func addFile(from sourcePath: String, as internalPath: String) throws {
        let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: sourcePath))
        defer { try? file.close() }
        let fileSize = Int64(try file.seekToEnd())
        try self.archive.addEntry(
            with: internalPath,
            type: .file,
            uncompressedSize: fileSize,
         // modificationDate: Date = Date(),
         // permissions: UInt16? = nil,
            compressionMethod: self.preset.compression,
         // bufferSize: Int = defaultWriteChunkSize,
         // progress: Progress? = nil
        ) { position, size -> Data in
         // defer { self.progressLocal = self.calculateProgress(current: position, maximum: fileSize) }
            try file.seek(toOffset: UInt64(position))
            let data = try file.read(upToCount: Int(size)) ?? Data()
            if Task.isCancelled { throw CancellationError() }
            return data
        }
    }

}
