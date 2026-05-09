
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

    public let sourcesInfo: CompresSource
    public let archivePath: String
    public let preset: CompresPreset

    fileprivate let archive: Archive

    init?(
        sourcesInfo: CompresSource,
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
            self.addEmptyDirsIfRequired()
        } catch {
            Logger.customLog("\(error.localizedDescription)")
            return nil
        }
    }

    private func addEmptyDirsIfRequired() {
        if (preset.isIncludeEmptyDirs) {
            if (!self.sourcesInfo.emptyDirectories.isEmpty) {
                for dirInfo in self.sourcesInfo.emptyDirectories {

                    var modificationDate: Date = Date()
                    if case .current           = self.preset.updatedMode                              { modificationDate = Date() }
                    if case .original          = self.preset.updatedMode, let dateInfo = dirInfo.date { modificationDate = dateInfo.updated }
                    if case .custom(let value) = self.preset.updatedMode                              { modificationDate = value.offsetted }

                    let internalPath = {
                        if (self.preset.isRelativePath)
                             { return dirInfo.relative }
                        else { return dirInfo.absolute }
                    }()

                    try? self.archive.addEntry(
                        with: dirInfo.relative,
                        type: .directory,
                        uncompressedSize: Int64(0),
                        modificationDate: modificationDate) { _, _ in
                            Data()
                        }
                }
            }
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
        self.total = sequence.sourcesInfo.files.count
        self.index = 0
    }

    func next() async -> CompresSequence.Element? {
        if (self.index < self.total) {

            defer { self.index += 1 }

            self.sequence.progressLocal = 0
            self.sequence.progressTotal = (self.index + 1).progress(
                max: self.total
            )

            let fileInfo = self.sequence.sourcesInfo.files[self.index]

            let internalPath = {
                if (self.sequence.preset.isRelativePath)
                     { return fileInfo.relative }
                else { return fileInfo.absolute }
            }()

            var modificationDate: Date = Date()
            if case .current           = self.sequence.preset.updatedMode                               { modificationDate = Date() }
            if case .original          = self.sequence.preset.updatedMode, let dateInfo = fileInfo.date { modificationDate = dateInfo.updated }
            if case .custom(let value) = self.sequence.preset.updatedMode                               { modificationDate = value.offsetted }

            do {
                try await self.addFile(
                    from: fileInfo.absolute,
                    as: internalPath,
                    modificationDate: modificationDate
                )
                return CompresSequence.Element(
                    status    : .success,
                    index     : self.index,
                    sourcePath: fileInfo.absolute
                )
            } catch is CancellationError {
                return CompresSequence.Element(
                    status    : .cancelledByUser,
                    index     : self.index,
                    sourcePath: fileInfo.absolute
                )
            } catch let error as NSError {
                return CompresSequence.Element(
                    status    : .failure(code: error.code, text: error.localizedDescription),
                    index     : self.index,
                    sourcePath: fileInfo.absolute
                )
            }
        }
        return nil
    }

    private func addFile(
        from sourcePath: String,
        as internalPath: String,
        modificationDate: Date
    ) async throws {
        let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: sourcePath))
        let fileSize = Int64(try file.seekToEnd())
        defer { try? file.close() }
        defer { if (fileSize == 0) { self.sequence.progressLocal = 1.0 } }
        try self.sequence.archive.addEntry(
            with: internalPath,
            type: .file,
            uncompressedSize: fileSize,
            modificationDate: modificationDate,
         // permissions: UInt16? = nil,
            compressionMethod: self.sequence.preset.compression,
         // bufferSize: Int = defaultWriteChunkSize,
         // progress: Progress? = nil
        ) { position, size -> Data in
            if (Task.isCancelled) { throw CancellationError() }
            if let throttling = self.sequence.preset.throttling { Thread.sleep(forTimeInterval: throttling) }
            try file.seek(toOffset: UInt64(position))
            let result = try file.read(upToCount: Int(size)) ?? Data()
            self.sequence.progressLocal = (position + Int64(size)).progress(max: fileSize)
            return result
        }
    }

}
