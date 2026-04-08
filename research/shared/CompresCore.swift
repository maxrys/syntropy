
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import Foundation
import ZIPFoundation

final class CompresCore: ObservableObject {

    @Published public private(set) var progressTotal: Double = 0.0
    @Published public private(set) var progressLocal: Double = 0.0
    @Published public private(set) var report: [String] = []

    public let sourcePaths: [String]
    public let archivePath: String
    public let preset: CompresPreset
    public let sharedPrefix: String?

    private let archive: Archive

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

    public func start() {

        self.progressTotal = 0.0
        self.progressLocal = 0.0
        self.report = []

        for (index, sourcePath) in self.sourcePaths.enumerated() {

            let internalPath = {
                if let sharedPrefix = self.sharedPrefix
                     { return sourcePath.trimPrefix(sharedPrefix) }
                else { return sourcePath }
            }()

            do {
                self.report.append("\(sourcePath)")
                let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: sourcePath))
                let fileSize = Int64(try file.seekToEnd())
                try self.archive.addEntry(
                    with: internalPath,
                    type: .file,
                    uncompressedSize: fileSize,
                    compressionMethod: self.preset.compression,
                ) { position, size -> Data in
                    defer { self.progressLocal = self.calculateProgress(current: position, maximum: fileSize) }
                    try file.seek(toOffset: UInt64(position))
                    let data = try file.read(upToCount: Int(size)) ?? Data()
                    return data
                }
                try file.close()
            } catch {
            }

            self.progressTotal = self.calculateProgress(
                current: index + 1,
                maximum: self.sourcePaths.count
            )

        }

        self.progressTotal = 1.0
        self.progressLocal = 1.0
    }

    private func calculateProgress(current: any BinaryInteger, maximum: any BinaryInteger) -> Double {
        let result = Double(current) / Double(maximum)
        return result.isNaN ? 0 : result.fixBounds(
            min: 0.0,
            max: 1.0
        )
    }

}
