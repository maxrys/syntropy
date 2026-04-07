
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
    }
    let value: Value
    let index: Int
    let path: String
    let progress: Double
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
    private var pathSharedPrefix: String?
    private let total: Int
    private var index: Int

    init(root sequence: CompresAsync) {
        self.sequence = sequence
        self.total = sequence.sourcePaths.count
        self.index = 0
        if (sequence.isTrimPrefix) {
            self.pathSharedPrefix = FileManager.pathsSharedPrefix(
                sequence.sourcePaths
            )
        }
    }

    mutating func next() async -> CompresAsync.Element? {
        if (self.index < self.total) {
            let pregress = Double(self.index + 1) / Double(self.total)
            let sourcePath = self.sequence.sourcePaths[self.index]
            let stepResult = await self.payloadStep(sourcePath)
            defer { self.index += 1 }
            return CompresAsync.Element(
                value: stepResult,
                index: self.index,
                path: sourcePath,
                progress: pregress
            )
        }
        return nil
    }

    private func payloadStep(_ sourcePath: String) async -> CompresAsync.Element.Value {
        do {
            let sourceURL = URL(fileURLWithPath: sourcePath)
            let internalPath = self.pathSharedPrefix != nil ? sourcePath.trimPrefix(self.pathSharedPrefix!) : sourcePath
         // try self.sequence.archive.addEntry(with: internalPath, fileURL: sourceURL)
            try await self.addFile(from: sourceURL, internalPath: internalPath)
            return .seccess
        } catch let error as NSError {
            Logger.customLog("\(error.localizedDescription)")
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
         // if Task.isCancelled { throw CancellationError() }
            return data
        }
    }

}
