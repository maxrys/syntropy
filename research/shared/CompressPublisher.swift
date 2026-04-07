
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation
import Combine

struct CompressPublisher: Publisher {

    typealias Output = Int
    typealias Failure = Never

    let count: Int

    init(count: Int) {
        self.count = count
    }

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Int == S.Input {
        let subscription = CompressSubscription(subscriber: subscriber, count: count)
        subscriber.receive(subscription: subscription)
    }

}

private final class CompressSubscription<S: Subscriber>: Subscription where S.Input == Int, S.Failure == Never {

    private var subscriber: S?
    private let count: Int

    init(subscriber: S, count: Int) {
        self.subscriber = subscriber
        self.count = count
    }

    func request(_ demand: Subscribers.Demand) {
        for i in 0 ..< self.count {
            _ = self.subscriber?.receive(i)
        }
        self.subscriber?.receive(
            completion: .finished
        )
    }

    func cancel() {
        self.subscriber = nil
    }

}
