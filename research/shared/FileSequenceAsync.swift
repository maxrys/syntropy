
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

struct FileSequenceAsync: AsyncSequence {

    typealias Element = FileSequenceIteratorAsync.StepResult

    private let handle: FileHandle

    public let chunkSize: UInt
    public let totalSize: UInt

    init?(path: String, chunkSize: UInt? = nil) {
        do {
            guard FileManager.default.fileExists(atPath: path) else {
                return nil
            }

            let url = URL(fileURLWithPath: path)
            let sizeAttribute = try url.resourceValues(forKeys: [.fileSizeKey])
            let totalSize = UInt(sizeAttribute.fileSize ?? 0)

            if (totalSize == 0) { return nil }
            if (chunkSize == 0) { return nil }

            self.totalSize = totalSize
            if let chunkSize
                 { self.chunkSize = chunkSize }
            else { self.chunkSize = (totalSize / 100).fixBounds(min: 1, max: 0xFFFFFF /* 16 MiB */ ) }

            self.handle = try FileHandle(
                forReadingFrom: url
            )
        } catch {
            Logger.customLog("\(error.localizedDescription)")
            return nil
        }
    }

    func makeAsyncIterator() -> FileSequenceIteratorAsync {
        FileSequenceIteratorAsync(
            handle   : self.handle,
            chunkSize: self.chunkSize,
            totalSize: self.totalSize
        )
    }

}

struct FileSequenceIteratorAsync: AsyncIteratorProtocol {

    struct StepResult {

        enum Status {
            case success
            case failure(code: Int, text: String)
            case cancelledByUser
        }

        let status: Status
        let offset: UInt
        let data: Data?
        let progress: Double

    }

    private let handle: FileHandle
    private let chunkSize: UInt
    private let totalSize: UInt
    private var offset: UInt

    init(handle: FileHandle, chunkSize: UInt, totalSize: UInt) {
        self.handle    = handle
        self.chunkSize = chunkSize
        self.totalSize = totalSize
        self.offset    = 0
    }

    private func calculateProgress(current: any BinaryInteger, maximum: any BinaryInteger) -> Double {
        let result = Double(current) / Double(maximum)
        return result.isNaN ? 0 : result.fixBounds(
            min: 0.0,
            max: 1.0
        )
    }

    mutating func next() async -> FileSequenceAsync.Element? {
        defer {
            self.offset = (self.offset + self.chunkSize).fixBounds(
                max: self.totalSize
            )
        }

        let progress = self.calculateProgress(
            current: self.offset + self.chunkSize,
            maximum: self.totalSize
        )

        if Task.isCancelled {
            return FileSequenceAsync.Element(
                status  : .cancelledByUser,
                offset  : self.offset,
                data    : nil,
                progress: progress
            )
        }

        let data = self.handle.readData(
            ofLength: Int(self.chunkSize)
        )

        if (data.isEmpty) {
            self.handle.closeFile()
            return nil
        }

        return FileSequenceAsync.Element(
            status  : .success,
            offset  : self.offset,
            data    : data,
            progress: progress
        )
    }

}
