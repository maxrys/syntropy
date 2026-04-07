
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

struct CompresStepResult {

    enum Value {
        case success
        case failure(code: Int, text: String)
        case cancellationByUser
    }

    let value: Value
    let index: Int
    let progress: Double
    let object: String

}
