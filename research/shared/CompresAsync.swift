
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

struct CompresAsync: AsyncSequence {

    typealias Element = CompresStepResult

    public let sourcePaths: [String]
    public let archivePath: String
    public let preset: CompresPreset
    public let sharedPrefix: String?

    fileprivate let archive: Archive

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

    func makeAsyncIterator() -> CompresAsyncIterator {
        CompresAsyncIterator(
            root: self
        )
    }

}

struct CompresAsyncIterator: AsyncIteratorProtocol {

    private let sequence: CompresAsync
    private let total: Int
    private var index: Int

    init(root sequence: CompresAsync) {
        self.sequence = sequence
        self.total = sequence.sourcePaths.count
        self.index = 0
    }

    private func calculateProgress(current: any BinaryInteger, maximum: any BinaryInteger) -> Double {
        let result = Double(current) / Double(maximum)
        return result.isNaN ? 0 : result.fixBounds(
            min: 0.0,
            max: 1.0
        )
    }

    mutating func next() async -> CompresAsync.Element? {
        if (self.index < self.total) {

            defer { self.index += 1 }

            let pregress = self.calculateProgress(
                current: self.index + 1,
                maximum: self.total
            )

            let sourcePath = self.sequence.sourcePaths[
                self.index
            ]

            let internalPath = {
                if let sharedPrefix = self.sequence.sharedPrefix
                     { return sourcePath.trimPrefix(sharedPrefix) }
                else { return sourcePath }
            }()

            do {
                try await self.addFile(
                    from: sourcePath,
                    as: internalPath
                )
                return CompresAsync.Element(
                    value   : .success,
                    index   : self.index,
                    progress: pregress,
                    object  : sourcePath
                )
            } catch is CancellationError {
                return CompresAsync.Element(
                    value   : .cancellationByUser,
                    index   : self.index,
                    progress: pregress,
                    object  : sourcePath
                )
            } catch let error as NSError {
                return CompresAsync.Element(
                    value   : .failure(code: error.code, text: error.localizedDescription),
                    index   : self.index,
                    progress: pregress,
                    object  : sourcePath
                )
            }
        }
        return nil
    }

    private func addFile(from sourcePath: String, as internalPath: String) async throws {
        let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: sourcePath))
        defer { try? file.close() }
        let fileSize = Int64(try file.seekToEnd())
        try self.sequence.archive.addEntry(
            with: internalPath,
            type: .file,
            uncompressedSize: fileSize,
         // modificationDate: Date = Date(),
         // permissions: UInt16? = nil,
            compressionMethod: self.sequence.preset.compression,
         // bufferSize: Int = defaultWriteChunkSize,
         // progress: Progress? = nil
        ) { position, size -> Data in
            try file.seek(toOffset: UInt64(position))
            let data = try file.read(upToCount: Int(size)) ?? Data()
            if Task.isCancelled { throw CancellationError() }
            return data
        }
    }

}
