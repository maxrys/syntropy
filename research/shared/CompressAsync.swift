
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation
import ZIPFoundation

struct CompresAsyncResult {
    let isSuccessed: Bool
    let index: Int
    let path: String
    let progress: Double
}

struct CompresAsync: AsyncSequence {

    typealias Element = CompresAsyncResult

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

    mutating func next() async -> CompresAsyncResult? {
        if (self.index < self.total) {
            let pregress = Double(self.index + 1) / Double(self.total)
            let sourcePath = self.sequence.sourcePaths[self.index]
            let payloadResult = await self.payloadStep(sourcePath)
            defer { self.index += 1 }
            return CompresAsyncResult(
                isSuccessed: payloadResult,
                index: self.index,
                path: sourcePath,
                progress: pregress
            )
        }
        return nil
    }

    func payloadStep(_ sourcePath: String) async -> Bool {
        do {
            let sourceURL = URL(fileURLWithPath: sourcePath)
            if let pathSharedPrefix = self.pathSharedPrefix
                 { try self.sequence.archive.addEntry(with: sourcePath.trimPrefix(pathSharedPrefix), fileURL: sourceURL) }
            else { try self.sequence.archive.addEntry(with: sourcePath                             , fileURL: sourceURL) }
            return true
        } catch {
            Logger.customLog("\(error.localizedDescription)")
            return false
        }
    }

}
