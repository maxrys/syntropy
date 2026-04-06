
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CompresAsyncResult {
    let isSuccessed: Bool
    let index: Int
    let progress: Double
}

struct CompresAsync: AsyncSequence {

    typealias Element = CompresAsyncResult

    private var total: Int = 0

    init(_ total: Int) {
        self.total = total
    }

    func makeAsyncIterator() -> CompresAsyncIterator {
        CompresAsyncIterator(self.total)
    }

}

struct CompresAsyncIterator: AsyncIteratorProtocol {

    private var index: Int = 0
    private var total: Int = 0

    init(_ total: Int) {
        self.total = total
    }

    mutating func next() async -> CompresAsyncResult? {
        if (self.index < self.total) {
            let result = await self.payloadStep()
            defer { self.index += 1 }
            return CompresAsyncResult(
                isSuccessed: result,
                index: self.index,
                progress: Double(self.index + 1) / Double(self.total)
            )
        }
        return nil
    }

    func payloadStep() async -> Bool {
        // Task.detached {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return true
        // }
    }

}
