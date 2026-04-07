
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

struct CompresAsyncStepResult {
    enum Value {
        case seccess
        case failure(code: Int, text: String)
        case cancelTask
    }
    let value: Value
    let index: Int
    let progress: Double
    let object: String
}

struct CompresAsync: AsyncSequence {

    typealias Element = CompresAsyncStepResult

    fileprivate let sourcePaths: [String]
    fileprivate let destinationPath: String
    fileprivate let isTrimPrefix: Bool
    fileprivate let archive: Archive

    init?(
        from sourcePaths: [String],
        to destinationPath: String,
        isTrimPrefix: Bool = true
    ) {
        self.sourcePaths = sourcePaths
        self.destinationPath = destinationPath
        self.isTrimPrefix = isTrimPrefix
        do {
            self.archive = try Archive(
                url: URL(fileURLWithPath: self.destinationPath),
                accessMode: .create
            )
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
    private var sharedPrefix: String?
    private let total: Int
    private var index: Int

    init(root sequence: CompresAsync) {
        self.sequence = sequence
        self.total = sequence.sourcePaths.count
        self.index = 0
        if (sequence.isTrimPrefix) {
            self.sharedPrefix = FileManager.pathsSharedPrefix(
                sequence.sourcePaths
            )
        }
    }

    mutating func next() async -> CompresAsync.Element? {
        if (self.index < self.total) {
            defer { self.index += 1 }
            let pregress = Double(self.index + 1) / Double(self.total)
            let sourcePath = self.sequence.sourcePaths[self.index]
            let stepResult = await self.payloadStep(sourcePath)
            return CompresAsync.Element(
                value: stepResult,
                index: self.index,
                progress: pregress,
                object: sourcePath
            )
        }
        return nil
    }

    private func payloadStep(_ sourcePath: String) async -> CompresAsync.Element.Value {
        do {
            let sourceURL = URL(fileURLWithPath: sourcePath)
            let internalPath = sharedPrefix.ifNotNil({ sourcePath.trimPrefix($0) }, else: sourcePath)
            try await self.addFile(from: sourceURL, internalPath: internalPath)
            return .seccess
        } catch is CancellationError {
            return .cancelTask
        } catch let error as NSError {
            return .failure(
                code: error.code,
                text: error.localizedDescription
            )
        }
    }

    private func addFile(from fileURL: URL, internalPath: String) async throws {
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        defer { try? fileHandle.close() }
        try self.sequence.archive.addEntry(
            with: internalPath,
            type: .file,
            uncompressedSize: Int64(try fileHandle.seekToEnd())
        ) { position, size -> Data in
            try fileHandle.seek(toOffset: UInt64(position))
            let data = try fileHandle.read(upToCount: Int(size)) ?? Data()
            if Task.isCancelled { throw CancellationError() }
            return data
        }
    }

}
