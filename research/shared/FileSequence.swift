
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

struct FileSequence: AsyncSequence {

    typealias Element = FileSequenceIterator.StepResult

    private let handle: FileHandle
    private let chunkSize: UInt
    private let totalSize: UInt

    init?(path: String, chunkSize: UInt = 0xFFFFF) {
        do {
            guard FileManager.default.fileExists(atPath: path) else {
                return nil
            }
            let fileURL = URL(fileURLWithPath: path)
            let fileSizeAttribute = try fileURL.resourceValues(forKeys: [.fileSizeKey])
            self.handle = try FileHandle(forReadingFrom: fileURL)
            self.totalSize = UInt(fileSizeAttribute.fileSize ?? 0)
            self.chunkSize = chunkSize
        } catch {
            Logger.customLog("\(error.localizedDescription)")
            return nil
        }
    }

    func makeAsyncIterator() -> FileSequenceIterator {
        FileSequenceIterator(
            handle   : self.handle,
            chunkSize: self.chunkSize,
            totalSize: self.totalSize
        )
    }

}

struct FileSequenceIterator: AsyncIteratorProtocol {

    struct StepResult {

        enum Status {
            case success
            case failure(code: Int, text: String)
            case cancellationByUser
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

    mutating func next() async -> FileSequence.Element? {
        defer {
            self.offset += self.chunkSize
        }

        let pregress = self.calculateProgress(
            current: self.offset,
            maximum: self.totalSize
        )

        if Task.isCancelled {
            return FileSequence.Element(
                status  : .cancellationByUser,
                offset  : self.offset,
                data    : nil,
                progress: pregress
            )
        }

        let data = self.handle.readData(
            ofLength: Int(self.chunkSize)
        )

        if (data.isEmpty) {
            self.handle.closeFile()
            return nil
        }

        return FileSequence.Element(
            status  : .success,
            offset  : self.offset,
            data    : data,
            progress: pregress
        )
    }

}
