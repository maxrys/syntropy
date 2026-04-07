
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension Optional {

    /* example:
           let prefix = "/some/prefix/in/file/path/"
           let path = prefix.ifNotNil({ prefix in path.trimPrefix(prefix) }, else: path)
     */

    func ifNotNil<T>(
        _ ifNotNilClosure: (Wrapped) -> T,
        else ifNilValue: T
    ) -> T {
        switch self {
            case .some(let value): return ifNotNilClosure(value)
            case .none           : return ifNilValue
        }
    }

}
