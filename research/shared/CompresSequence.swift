
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import ZIPFoundation
import SwiftUI

final class CompresSequence: AsyncSequence {

    typealias Element = CompresSequenceIterator.StepResult

    @Binding var progressTotal: Double
    @Binding var progressLocal: Double

    public let sourcesInfo: CompresSourceInfo
    public let archivePath: String
    public let preset: CompresPreset

    fileprivate let archive: Archive

    init?(
        sourcesInfo: CompresSourceInfo,
        archivePath: String,
        preset: CompresPreset,
        progressTotal: Binding<Double>,
        progressLocal: Binding<Double>
    ) {
        do {
            self.archive = try Archive(
                url: URL(fileURLWithPath: archivePath),
                accessMode: .create
            )
            self.sourcesInfo = sourcesInfo
            self.archivePath = archivePath
            self.preset = preset
            self._progressTotal = progressTotal
            self._progressLocal = progressLocal
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

final class CompresSequenceIterator: AsyncIteratorProtocol {

    struct StepResult {
        enum Status {
            case success
            case failure(code: Int, text: String)
            case cancelledByUser
        }
        let status: Status
        let index: Int
        let sourcePath: String
    }

    private let sequence: CompresSequence
    private let total: Int
    private var index: Int

    init(root sequence: CompresSequence) {
        self.sequence = sequence
        self.total = sequence.sourcesInfo.dataSet.files.count
        self.index = 0
    }

    func next() async -> CompresSequence.Element? {
        if (self.index < self.total) {

            defer { self.index += 1 }

            self.sequence.progressLocal = 0
            self.sequence.progressTotal = (self.index + 1).progress(
                max: self.total
            )

            let sourcePath     = self.sequence.sourcesInfo.dataSet.files[self.index].path
            let sourceBasePath = self.sequence.sourcesInfo.dataSet.files[self.index].basePath

            let internalPath = {
                if (self.sequence.preset.isTrimPrefix)
                     { return sourcePath.trimPrefix(sourceBasePath) }
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
             // } else {}
                return CompresSequence.Element(
                    status    : .success,
                    index     : self.index,
                    sourcePath: sourcePath
                )
            } catch is CancellationError {
                return CompresSequence.Element(
                    status    : .cancelledByUser,
                    index     : self.index,
                    sourcePath: sourcePath
                )
            } catch let error as NSError {
                return CompresSequence.Element(
                    status    : .failure(code: error.code, text: error.localizedDescription),
                    index     : self.index,
                    sourcePath: sourcePath
                )
            }
        }
        return nil
    }

    private func addFile(from sourcePath: String, as internalPath: String) async throws {
        let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: sourcePath))
        let fileSize = Int64(try file.seekToEnd())
        defer { try? file.close() }
        defer { if (fileSize == 0) { self.sequence.progressLocal = 1.0 } }
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
         // Thread.sleep(forTimeInterval: 0.01)
            try file.seek(toOffset: UInt64(position))
            let result = try file.read(upToCount: Int(size)) ?? Data()
            self.sequence.progressLocal = (position + Int64(size)).progress(max: fileSize)
            return result
        }
    }

}
