
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

struct FileSequence: AsyncSequence {

    typealias Element = FileSequenceIterator.StepResult

    private let handle: FileHandle

    init?(path: String) {
        do {
            guard FileManager.default.fileExists(atPath: path) else {
                return nil
            }
            self.handle = try FileHandle(
                forReadingFrom: URL(fileURLWithPath: path)
            )
        } catch {
            Logger.customLog("\(error.localizedDescription)")
            return nil
        }
    }

    func makeAsyncIterator() -> FileSequenceIterator {
        FileSequenceIterator(
            handle: self.handle
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
        let offset: Int
        let data: Data
        let progress: Double

    }

    private let handle: FileHandle
    private let total: Int
    private var index: Int

    init(handle: FileHandle) {
        self.handle = handle
        self.total = 100
        self.index = 0
    }

    private func calculateProgress(current: any BinaryInteger, maximum: any BinaryInteger) -> Double {
        let result = Double(current) / Double(maximum)
        return result.isNaN ? 0 : result.fixBounds(
            min: 0.0,
            max: 1.0
        )
    }

    mutating func next() async -> FileSequence.Element? {
        if (self.index < self.total) {

            defer { self.index += 1 }

            let pregress = self.calculateProgress(
                current: self.index + 1,
                maximum: self.total
            )

            try? await Task.sleep(
                nanoseconds: 100_000_000
            )

            if Task.isCancelled {
                return FileSequence.Element(
                    status  : .cancellationByUser,
                    offset  : self.index * 5,
                    data    : Data([]),
                    progress: pregress
                )
            }

            return FileSequence.Element(
                status  : .success,
                offset  : self.index * 5,
                data    : Data([0,1,2,3,4]),
                progress: pregress
            )
        }

        /*
        let data = fileHandle.readData(ofLength: 1024)

        // Если конец файла, закрываем хэндл и возвращаем nil
        if data.isEmpty {
            fileHandle.closeFile()
            return nil
        }

        // Преобразование данных в строку
        let newLines = String(data: data, encoding: .utf8)?
            .components(separatedBy: .newlines)

        if let lastLine = newLines?.last, let buffer = buffer {
            self.buffer = buffer + lastLine // Сохраняем остаток строки
            return buffer
        } else {
            return newLines?.first // Возвращаем первую строку
        }
         */

        return nil
    }

}
