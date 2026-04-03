
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

struct AppURL: Codable {

    public private(set) var operationType: OperationType
    public private(set) var paths: [String] = []

    init(operationType: OperationType, _ paths: [String]) {
        self.operationType = operationType
        self.paths = paths
    }

    init?(decode url: URL) {
        do {
            guard let urlComponents = URLComponents(string: url.absoluteString)                                else { return nil }
            guard let urlQueryDataValue = urlComponents.queryItems?.first(where: { $0.name == "data" })?.value else { return nil }
            guard let jsonData = urlQueryDataValue.data(using: .utf8)                                          else { return nil }
            self = try JSONDecoder().decode(
                Self.self,
                from: jsonData
            )
        } catch {
            return nil
        }
    }

    func encode() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(
            data: data,
            encoding: .utf8
        )
    }

}
