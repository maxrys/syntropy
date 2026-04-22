
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

struct CompresSequence: AsyncSequence {

    typealias Element = CompresSequenceIterator.StepResult

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

    func makeAsyncIterator() -> CompresSequenceIterator {
        CompresSequenceIterator(
            root: self
        )
    }

}

struct CompresSequenceIterator: AsyncIteratorProtocol {

    struct StepResult {

        enum Status {
            case success
            case failure(code: Int, text: String)
            case cancelledByUser
        }

        let status: Status
        let index: Int
        let progress: Double
        let sourcePath: String

    }

    private let sequence: CompresSequence
    private let total: Int
    private var index: Int

    init(root sequence: CompresSequence) {
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

    mutating func next() async -> CompresSequence.Element? {
        if (self.index < self.total) {

            defer { self.index += 1 }

            let progress = self.calculateProgress(
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
             // if let fileSequence = FileSequence(path: sourcePath, chunkSize: nil) {
             //     var iterator = fileSequence.makeIterator()
             //     try self.sequence.archive.addEntry(
             //         with: internalPath,
             //         type: .file,
             //         uncompressedSize: Int64(fileSequence.totalSize),
             //         compressionMethod: self.sequence.preset.compression,
             //         bufferSize: Int(fileSequence.chunkSize),
             //     ) { _, _ -> Data in
             //         if Task.isCancelled { throw CancellationError() }
             //         return iterator.next()?.data ?? Data()
             //     }
             // } else {
             // }
                return CompresSequence.Element(
                    status    : .success,
                    index     : self.index,
                    progress  : progress,
                    sourcePath: sourcePath
                )
            } catch is CancellationError {
                return CompresSequence.Element(
                    status    : .cancelledByUser,
                    index     : self.index,
                    progress  : progress,
                    sourcePath: sourcePath
                )
            } catch let error as NSError {
                return CompresSequence.Element(
                    status    : .failure(code: error.code, text: error.localizedDescription),
                    index     : self.index,
                    progress  : progress,
                    sourcePath: sourcePath
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
            if Task.isCancelled { throw CancellationError() }
            try file.seek(toOffset: UInt64(position))
            return try file.read(upToCount: Int(size)) ?? Data()
        }
    }

}
